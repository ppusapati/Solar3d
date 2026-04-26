package file

import (
	"errors"
	"io"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"github.com/fsnotify/fsnotify"

	"p9e.in/samavaya/packages/config"
	"p9e.in/samavaya/packages/p9log"
)

var _ config.Source = (*file)(nil)

type file struct {
	path string
}

// NewSource new a file source.
func NewSource(path string) config.Source {
	return &file{path: path}
}
func getFileExtension(filename string) string {
	ext := filepath.Ext(filename)
	if len(ext) > 0 {
		return ext[1:]
	}
	return ""
}

func (f *file) loadFile(path string) (*config.KeyValue, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	data, err := io.ReadAll(file)
	if err != nil {
		return nil, err
	}
	info, err := file.Stat()
	if err != nil {
		return nil, err
	}
	return &config.KeyValue{
		Key:    info.Name(),
		Format: getFileExtension(info.Name()),
		Value:  data,
	}, nil
}

func (f *file) loadDir(path string) (kvs []*config.KeyValue, err error) {
	files, err := os.ReadDir(path)
	if err != nil {
		return nil, err
	}
	for _, file := range files {
		// ignore hidden files
		if file.IsDir() || strings.HasPrefix(file.Name(), ".") {
			continue
		}
		kv, err := f.loadFile(filepath.Join(path, file.Name()))
		if err != nil {
			return nil, err
		}
		kvs = append(kvs, kv)
	}
	return
}

func (f *file) Load() (kvs []*config.KeyValue, err error) {

	fi, err := os.Stat(f.path)
	p9log.Error(err)
	if err != nil {
		return nil, err
	}
	if fi.IsDir() {
		return f.loadDir(f.path)
	}
	kv, err := f.loadFile(f.path)
	if err != nil {
		return nil, err
	}
	return []*config.KeyValue{kv}, nil
}

func (f *file) Watch() (config.Watcher, error) {
	return newWatcher(f)
}

// fileWatcher uses fsnotify to deliver Load() snapshots whenever the watched
// path changes on disk. It coalesces bursts of events (editors often emit
// rename + create + write within milliseconds) by waiting for a 100ms quiet
// window before reloading. Calls to Next() block until either a change has
// been observed or Stop() is invoked.
type fileWatcher struct {
	source  *file
	notify  *fsnotify.Watcher
	dirty   chan struct{}
	stopped chan struct{}
	once    sync.Once
}

const watchCoalesceWindow = 100 * time.Millisecond

func newWatcher(src *file) (config.Watcher, error) {
	notify, err := fsnotify.NewWatcher()
	if err != nil {
		return nil, err
	}
	target := src.path
	if fi, statErr := os.Stat(target); statErr == nil && !fi.IsDir() {
		// Watch the parent directory so file replacements (rename + create,
		// the pattern used by atomic config writers) still produce events.
		target = filepath.Dir(target)
	}
	if err := notify.Add(target); err != nil {
		_ = notify.Close()
		return nil, err
	}
	w := &fileWatcher{
		source:  src,
		notify:  notify,
		dirty:   make(chan struct{}, 1),
		stopped: make(chan struct{}),
	}
	go w.loop()
	return w, nil
}

func (w *fileWatcher) loop() {
	var pending bool
	var timer *time.Timer
	for {
		select {
		case <-w.stopped:
			return
		case ev, ok := <-w.notify.Events:
			if !ok {
				return
			}
			if !w.relevant(ev) {
				continue
			}
			pending = true
			if timer == nil {
				timer = time.NewTimer(watchCoalesceWindow)
			} else {
				if !timer.Stop() {
					select {
					case <-timer.C:
					default:
					}
				}
				timer.Reset(watchCoalesceWindow)
			}
		case <-timerFire(timer):
			if pending {
				pending = false
				select {
				case w.dirty <- struct{}{}:
				default:
				}
			}
		case err, ok := <-w.notify.Errors:
			if !ok {
				return
			}
			p9log.Error(err)
		}
	}
}

// timerFire returns the timer's channel, or a nil channel that never fires
// when the timer is itself nil.
func timerFire(t *time.Timer) <-chan time.Time {
	if t == nil {
		return nil
	}
	return t.C
}

// relevant filters events that don't affect the watched path. We accept any
// event whose Name shares the parent directory with our source; consumers
// re-load the entire source so per-file granularity is unnecessary.
func (w *fileWatcher) relevant(ev fsnotify.Event) bool {
	if ev.Name == "" {
		return false
	}
	want, _ := filepath.Abs(w.source.path)
	got, _ := filepath.Abs(ev.Name)
	if want == got {
		return true
	}
	// If the source path is a directory, accept any event inside it.
	if fi, err := os.Stat(w.source.path); err == nil && fi.IsDir() {
		return strings.HasPrefix(got, want)
	}
	// File-mode: also accept events on siblings since editors rename through
	// temporary names that resolve to a different basename briefly.
	return filepath.Dir(want) == filepath.Dir(got)
}

func (w *fileWatcher) Next() ([]*config.KeyValue, error) {
	select {
	case <-w.stopped:
		return nil, errors.New("config file watcher: stopped")
	case <-w.dirty:
		return w.source.Load()
	}
}

func (w *fileWatcher) Stop() error {
	var err error
	w.once.Do(func() {
		close(w.stopped)
		err = w.notify.Close()
	})
	return err
}
