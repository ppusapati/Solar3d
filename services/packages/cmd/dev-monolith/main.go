package main

import (
	"bufio"
	"context"
	"errors"
	"flag"
	"fmt"
	"io"
	"net"
	"net/url"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"sync"
	"syscall"
	"time"
)

type processSpec struct {
	name    string
	dir     string
	command []string
	env     []string
}

const (
	graphGRPCPort        = 46061
	mlServiceGRPCPort    = 46063
	optimizationGRPCPort = 46062
)

type processResult struct {
	name string
	err  error
}

type servicePort struct {
	service string
	port    int
}

type syncWriter struct {
	mu  sync.Mutex
	dst io.Writer
}

func (w *syncWriter) println(msg string) {
	w.mu.Lock()
	defer w.mu.Unlock()
	_, _ = fmt.Fprintln(w.dst, msg)
}

func main() {
	includeFrontend := flag.Bool("frontend", true, "start frontend via pnpm dev")
	only := flag.String("only", "", "comma separated service directories to run (example: drawing-revision-service,cad-core-service)")
	flag.Parse()

	repoRoot, err := findRepoRoot()
	if err != nil {
		fmt.Fprintf(os.Stderr, "fatal: %v\n", err)
		os.Exit(1)
	}

	servicesRoot := filepath.Join(repoRoot, "services")
	serviceNames, err := discoverServiceDirs(servicesRoot)
	if err != nil {
		fmt.Fprintf(os.Stderr, "fatal: discover services: %v\n", err)
		os.Exit(1)
	}

	if strings.TrimSpace(*only) != "" {
		serviceNames, err = filterServices(serviceNames, *only)
		if err != nil {
			fmt.Fprintf(os.Stderr, "fatal: %v\n", err)
			os.Exit(1)
		}
	}

	if len(serviceNames) == 0 {
		fmt.Fprintln(os.Stderr, "fatal: no services selected")
		os.Exit(1)
	}

	ports := requiredPorts(serviceNames, *includeFrontend)
	conflicts := findPortConflicts(ports)
	if len(conflicts) > 0 {
		fmt.Fprintln(os.Stderr, "fatal: required ports already in use")
		for _, conflict := range conflicts {
			fmt.Fprintf(os.Stderr, "  - %s requires :%d\n", conflict.service, conflict.port)
		}
		os.Exit(1)
	}

	logger := &syncWriter{dst: os.Stdout}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	commonEnv, envErr := buildCommonEnv(repoRoot)
	if envErr != nil {
		fmt.Fprintf(os.Stderr, "fatal: build environment: %v\n", envErr)
		os.Exit(1)
	}

	logger.println(fmt.Sprintf("repo root: %s", repoRoot))
	logger.println(fmt.Sprintf("starting %d services", len(serviceNames)))

	cmds := make([]*exec.Cmd, 0, len(serviceNames)+1)
	results := make(chan processResult, len(serviceNames)+1)

	for _, svc := range serviceNames {
		spec, specErr := serviceSpec(repoRoot, svc, commonEnv)
		if specErr != nil {
			fmt.Fprintf(os.Stderr, "fatal: %v\n", specErr)
			cancel()
			os.Exit(1)
		}

		cmd, startErr := startProcess(ctx, spec, logger)
		if startErr != nil {
			fmt.Fprintf(os.Stderr, "fatal: start %s: %v\n", spec.name, startErr)
			cancel()
			shutdown(cmds, logger)
			os.Exit(1)
		}
		cmds = append(cmds, cmd)
		go waitProcess(spec.name, cmd, results)
	}

	if *includeFrontend {
		frontendSpec := frontendProcessSpec(repoRoot)
		cmd, startErr := startProcess(ctx, frontendSpec, logger)
		if startErr != nil {
			fmt.Fprintf(os.Stderr, "fatal: start %s: %v\n", frontendSpec.name, startErr)
			cancel()
			shutdown(cmds, logger)
			os.Exit(1)
		}
		cmds = append(cmds, cmd)
		go waitProcess(frontendSpec.name, cmd, results)
	}

	logger.println("all processes started; press Ctrl+C to stop")

	for range cmds {
		select {
		case <-ctx.Done():
			logger.println("shutdown requested")
			shutdown(cmds, logger)
			return
		case res := <-results:
			if res.err == nil {
				logger.println(fmt.Sprintf("%s exited cleanly", res.name))
				continue
			}
			if errors.Is(res.err, context.Canceled) {
				continue
			}
			logger.println(fmt.Sprintf("%s exited with error: %v", res.name, res.err))
			cancel()
			shutdown(cmds, logger)
			return
		}
	}
}

func findRepoRoot() (string, error) {
	wd, err := os.Getwd()
	if err != nil {
		return "", err
	}

	cursor := wd
	for {
		if exists(filepath.Join(cursor, "services", "go.work")) && exists(filepath.Join(cursor, "frontend", "package.json")) {
			return cursor, nil
		}
		next := filepath.Dir(cursor)
		if next == cursor {
			return "", errors.New("could not find repository root containing services/go.work and frontend/package.json")
		}
		cursor = next
	}
}

func discoverServiceDirs(servicesRoot string) ([]string, error) {
	entries, err := os.ReadDir(servicesRoot)
	if err != nil {
		return nil, err
	}

	serviceNames := make([]string, 0, len(entries))
	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		name := entry.Name()
		if !strings.HasSuffix(name, "-service") {
			continue
		}
		if exists(filepath.Join(servicesRoot, name, "cmd", "server", "main.go")) || exists(filepath.Join(servicesRoot, name, "cmd", "main.go")) {
			serviceNames = append(serviceNames, name)
		}
	}

	sort.Strings(serviceNames)
	serviceNames = moveToEnd(serviceNames, "api-gateway-service")
	return serviceNames, nil
}

func filterServices(all []string, onlyCSV string) ([]string, error) {
	lookup := make(map[string]struct{}, len(all))
	for _, s := range all {
		lookup[s] = struct{}{}
	}

	parts := strings.Split(onlyCSV, ",")
	selected := make([]string, 0, len(parts))
	seen := make(map[string]struct{}, len(parts))
	for _, part := range parts {
		name := strings.TrimSpace(part)
		if name == "" {
			continue
		}
		if _, ok := lookup[name]; !ok {
			return nil, fmt.Errorf("unknown service in -only: %s", name)
		}
		if _, ok := seen[name]; ok {
			continue
		}
		seen[name] = struct{}{}
		selected = append(selected, name)
	}

	sort.Strings(selected)
	selected = moveToEnd(selected, "api-gateway-service")
	return selected, nil
}

func serviceSpec(repoRoot, serviceName string, commonEnv []string) (processSpec, error) {
	dir := filepath.Join(repoRoot, "services", serviceName)
	cmdServer := filepath.Join(dir, "cmd", "server", "main.go")
	cmdRoot := filepath.Join(dir, "cmd", "main.go")

	var args []string
	if exists(cmdServer) {
		args = []string{"go", "run", "./cmd/server/main.go"}
	} else if exists(cmdRoot) {
		args = []string{"go", "run", "./cmd/main.go"}
	} else {
		return processSpec{}, fmt.Errorf("%s has no supported main.go under cmd/", serviceName)
	}

	env := append([]string{}, commonEnv...)
	env = append(env, "GOWORK=off")
	if serviceName == "graph-service" {
		env = append(env, fmt.Sprintf("GRAPH_SERVICE_PORT=:%d", graphGRPCPort))
	}
	if serviceName == "ml-service" {
		env = append(env, fmt.Sprintf("ML_SERVICE_PORT=:%d", mlServiceGRPCPort))
	}
	if serviceName == "optimization-service" {
		env = append(env, fmt.Sprintf("OPTIMIZATION_SERVICE_PORT=:%d", optimizationGRPCPort))
	}

	return processSpec{
		name:    serviceName,
		dir:     dir,
		command: args,
		env:     env,
	}, nil
}

func frontendProcessSpec(repoRoot string) processSpec {
	args := []string{"pnpm", "dev", "--host", "0.0.0.0", "--port", "3000"}
	if runtime.GOOS == "windows" {
		args = []string{"cmd", "/c", "pnpm", "dev", "--host", "0.0.0.0", "--port", "3000"}
	}

	return processSpec{
		name:    "frontend",
		dir:     filepath.Join(repoRoot, "frontend"),
		command: args,
		env:     nil,
	}
}

func startProcess(ctx context.Context, spec processSpec, logger *syncWriter) (*exec.Cmd, error) {
	if len(spec.command) == 0 {
		return nil, errors.New("empty command")
	}

	cmd := exec.CommandContext(ctx, spec.command[0], spec.command[1:]...)
	cmd.Dir = spec.dir
	cmd.Env = append(os.Environ(), spec.env...)

	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return nil, err
	}
	stderr, err := cmd.StderrPipe()
	if err != nil {
		return nil, err
	}

	if err := cmd.Start(); err != nil {
		return nil, err
	}

	go streamOutput(spec.name, stdout, logger)
	go streamOutput(spec.name, stderr, logger)

	logger.println(fmt.Sprintf("started %s", spec.name))
	return cmd, nil
}

func streamOutput(name string, r io.Reader, logger *syncWriter) {
	scanner := bufio.NewScanner(r)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 1024*1024)
	for scanner.Scan() {
		line := scanner.Text()
		logger.println(fmt.Sprintf("[%s] %s", name, line))
	}
	if err := scanner.Err(); err != nil {
		logger.println(fmt.Sprintf("[%s] output stream error: %v", name, err))
	}
}

func waitProcess(name string, cmd *exec.Cmd, ch chan<- processResult) {
	err := cmd.Wait()
	ch <- processResult{name: name, err: err}
}

func shutdown(cmds []*exec.Cmd, logger *syncWriter) {
	time.Sleep(500 * time.Millisecond)
	for _, cmd := range cmds {
		if cmd == nil || cmd.Process == nil {
			continue
		}
		_ = cmd.Process.Kill()
	}
	logger.println("all child processes stopped")
}

func buildCommonEnv(repoRoot string) ([]string, error) {
	dotEnv, err := parseDotEnv(filepath.Join(repoRoot, ".env"))
	if err != nil {
		return nil, err
	}

	env := make([]string, 0, len(dotEnv)+2)
	keys := make([]string, 0, len(dotEnv))
	for key := range dotEnv {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	for _, key := range keys {
		if _, exists := os.LookupEnv(key); exists {
			continue
		}
		env = append(env, key+"="+dotEnv[key])
	}

	databaseURL := strings.TrimSpace(firstNonEmpty(os.Getenv("DATABASE_URL"), dotEnv["DATABASE_URL"]))
	if databaseURL == "" {
		user := firstNonEmpty(os.Getenv("POSTGRES_USER"), dotEnv["POSTGRES_USER"], "postgres")
		password := firstNonEmpty(os.Getenv("POSTGRES_PASSWORD"), dotEnv["POSTGRES_PASSWORD"], "postgres")
		host := firstNonEmpty(os.Getenv("POSTGRES_HOST"), dotEnv["POSTGRES_HOST"], "localhost")
		port := firstNonEmpty(os.Getenv("POSTGRES_PORT"), dotEnv["POSTGRES_PORT"], "5432")
		database := firstNonEmpty(os.Getenv("POSTGRES_DB"), dotEnv["POSTGRES_DB"], "postgres")
		sslMode := firstNonEmpty(os.Getenv("DB_SSLMODE"), dotEnv["DB_SSLMODE"], "disable")

		u := &url.URL{
			Scheme:   "postgres",
			Host:     net.JoinHostPort(host, port),
			Path:     "/" + database,
			RawQuery: "sslmode=" + url.QueryEscape(sslMode),
		}
		u.User = url.UserPassword(user, password)
		databaseURL = u.String()
	}

	logLevel := firstNonEmpty(os.Getenv("LOG_LEVEL"), dotEnv["LOG_LEVEL"], "DEBUG")
	env = append(env,
		"DATABASE_URL="+databaseURL,
		"LOG_LEVEL="+logLevel,
	)

	return env, nil
}

func parseDotEnv(path string) (map[string]string, error) {
	values := map[string]string{}
	file, err := os.Open(path)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return values, nil
		}
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		parts := strings.SplitN(line, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.TrimSpace(parts[0])
		if key == "" {
			continue
		}
		value := strings.TrimSpace(parts[1])
		value = strings.Trim(value, "\"")
		value = strings.Trim(value, "'")
		values[key] = value
	}
	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return values, nil
}

func firstNonEmpty(values ...string) string {
	for _, value := range values {
		trimmed := strings.TrimSpace(value)
		if trimmed != "" {
			return trimmed
		}
	}
	return ""
}

func exists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func moveToEnd(values []string, target string) []string {
	idx := -1
	for i, value := range values {
		if value == target {
			idx = i
			break
		}
	}
	if idx == -1 {
		return values
	}

	result := make([]string, 0, len(values))
	result = append(result, values[:idx]...)
	result = append(result, values[idx+1:]...)
	result = append(result, target)
	return result
}

func requiredPorts(serviceNames []string, includeFrontend bool) []servicePort {
	known := map[string][]int{
		"api-gateway-service":           {8090},
		"drawing-revision-service":      {8091},
		"cad-core-service":              {8092},
		"cad-annotation-service":        {8093},
		"cad-layer-block-service":       {8094},
		"interop-service":               {8095},
		"plot-sheet-service":            {8096},
		"project-service":               {8080},
		"terrain-service":               {8081},
		"layout-service":                {8082},
		"simulation-service":            {8083},
		"electrical-service":            {8084},
		"routing-service":               {8085},
		"report-service":                {8086},
		"asset-service":                 {8087},
		"compute-service":               {50051},
		"graph-service":                 {graphGRPCPort, 8061},
		"ml-service":                    {8063, mlServiceGRPCPort},
		"optimization-service":          {8062, optimizationGRPCPort},
		"compute-orchestration-service": {8070},
		"geo-analytics-service":         {8071},
	}

	result := make([]servicePort, 0, len(serviceNames)*2+1)
	seen := map[int]struct{}{}
	for _, service := range serviceNames {
		for _, port := range known[service] {
			if _, exists := seen[port]; exists {
				continue
			}
			seen[port] = struct{}{}
			result = append(result, servicePort{service: service, port: port})
		}
	}

	if includeFrontend {
		if _, exists := seen[3000]; !exists {
			result = append(result, servicePort{service: "frontend", port: 3000})
		}
	}

	sort.Slice(result, func(i, j int) bool {
		return result[i].port < result[j].port
	})
	return result
}

func findPortConflicts(required []servicePort) []servicePort {
	conflicts := make([]servicePort, 0)
	maxRetries := 5
	retryDelay := 1 * time.Second

	for _, entry := range required {
		addr := fmt.Sprintf(":%d", entry.port)
		var lastErr error

		for attempt := 0; attempt < maxRetries; attempt++ {
			ln, err := net.Listen("tcp", addr)
			if err == nil {
				_ = ln.Close()
				lastErr = nil
				break
			}
			lastErr = err
			if attempt < maxRetries-1 {
				fmt.Fprintf(os.Stderr, "waiting for port %d to be available (attempt %d/%d)...\n", entry.port, attempt+1, maxRetries)
				time.Sleep(retryDelay)
			}
		}

		if lastErr != nil {
			conflicts = append(conflicts, entry)
		}
	}
	return conflicts
}

