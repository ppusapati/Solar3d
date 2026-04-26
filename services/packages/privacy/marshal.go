package privacy

import (
	"bytes"
	"encoding/json"
)

// marshalIndent produces human-readable, stable-ordered JSON for export
// artifacts. Data subjects read these; prettiness matters.
func marshalIndent(v any) ([]byte, error) {
	var buf bytes.Buffer
	enc := json.NewEncoder(&buf)
	enc.SetIndent("", "  ")
	enc.SetEscapeHTML(false)
	if err := enc.Encode(v); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
