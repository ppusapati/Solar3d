package service

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestProtoCompatibility_BufLintGenerateBreaking(t *testing.T) {
	if _, err := exec.LookPath("buf"); err != nil {
		t.Skip("buf is not installed in test environment")
	}

	repoRoot, err := findRepoRoot()
	if err != nil {
		t.Fatalf("failed to find repo root: %v", err)
	}
	protoDir := filepath.Join(repoRoot, "proto")

	runCmd := func(name string, args ...string) {
		cmd := exec.Command(name, args...)
		cmd.Dir = protoDir
		out, err := cmd.CombinedOutput()
		if err != nil {
			t.Fatalf("command failed: %s %s\n%s", name, strings.Join(args, " "), string(out))
		}
	}

	runCmd("buf", "lint")
	runCmd("buf", "generate")

	if hasMainBranch(protoDir) {
		runCmd("buf", "breaking", "--against", ".git#branch=main")
	} else {
		t.Skip("skipping buf breaking test: main branch reference not available locally")
	}
}

func hasMainBranch(dir string) bool {
	cmd := exec.Command("git", "rev-parse", "--verify", "main")
	cmd.Dir = dir
	if err := cmd.Run(); err == nil {
		return true
	}
	cmd = exec.Command("git", "rev-parse", "--verify", "origin/main")
	cmd.Dir = dir
	return cmd.Run() == nil
}

func findRepoRoot() (string, error) {
	wd, err := os.Getwd()
	if err != nil {
		return "", err
	}
	cur := wd
	for {
		if _, err := os.Stat(filepath.Join(cur, "proto", "buf.yaml")); err == nil {
			return cur, nil
		}
		next := filepath.Dir(cur)
		if next == cur {
			break
		}
		cur = next
	}
	return "", os.ErrNotExist
}

