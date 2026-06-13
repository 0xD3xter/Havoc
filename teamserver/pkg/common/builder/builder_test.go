package builder

import (
	"strings"
	"testing"
)

func TestNewBuilderAddsGCC14CompatibilityFlags(t *testing.T) {
	expectedFlags := []string{
		"-Wno-error=incompatible-pointer-types",
		"-Wno-error=int-conversion",
		"-Wno-error=implicit-function-declaration",
	}

	tests := []struct {
		name     string
		debugDev bool
	}{
		{name: "release", debugDev: false},
		{name: "debug", debugDev: true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			builder := NewBuilder(BuilderConfig{DebugDev: tt.debugDev})
			cflags := strings.Join(builder.compilerOptions.CFlags, " ")

			for _, expectedFlag := range expectedFlags {
				if !strings.Contains(cflags, expectedFlag) {
					t.Fatalf("expected CFlags to include %q, got %q", expectedFlag, cflags)
				}
			}
		})
	}
}
