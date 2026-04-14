package handler

import (
	"bytes"
	"encoding/json"
	"io"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/rs/zerolog"
)

func makeMultipartBytes(t *testing.T, fieldName string, fileName string, payload []byte) ([]byte, string) {
	t.Helper()
	var body bytes.Buffer
	writer := multipart.NewWriter(&body)
	part, err := writer.CreateFormFile(fieldName, fileName)
	if err != nil {
		t.Fatalf("CreateFormFile failed: %v", err)
	}
	if _, err := io.Copy(part, bytes.NewReader(payload)); err != nil {
		t.Fatalf("copy payload failed: %v", err)
	}
	if err := writer.Close(); err != nil {
		t.Fatalf("close writer failed: %v", err)
	}
	return body.Bytes(), writer.FormDataContentType()
}

func makeMultipartRequest(t *testing.T, target string, fieldName string, fileName string, payload []byte) (*http.Request, string) {
	t.Helper()
	var body bytes.Buffer
	writer := multipart.NewWriter(&body)
	part, err := writer.CreateFormFile(fieldName, fileName)
	if err != nil {
		t.Fatalf("CreateFormFile failed: %v", err)
	}
	if _, err := io.Copy(part, bytes.NewReader(payload)); err != nil {
		t.Fatalf("copy payload failed: %v", err)
	}
	if err := writer.Close(); err != nil {
		t.Fatalf("close writer failed: %v", err)
	}

	req := httptest.NewRequest(http.MethodPost, target, &body)
	req.Header.Set("Content-Type", writer.FormDataContentType())
	return req, writer.FormDataContentType()
}

func TestParseCadFileREST_DXFSuccess(t *testing.T) {
	h := NewProjectHandler(nil, zerolog.Nop())
	dxf := []byte("0\nSECTION\n2\nENTITIES\n0\nLWPOLYLINE\n8\nBOUNDARY\n70\n1\n10\n76.5\n20\n12.1\n10\n76.6\n20\n12.1\n10\n76.6\n20\n12.2\n10\n76.5\n20\n12.2\n0\nENDSEC\n0\nEOF\n")

	req, _ := makeMultipartRequest(t, "/api/v1/cad/parse", "file", "site.dxf", dxf)
	rr := httptest.NewRecorder()

	h.ParseCadFileREST(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected 200, got %d body=%s", rr.Code, rr.Body.String())
	}

	var payload struct {
		SourceFormat string   `json:"source_format"`
		Layers       []string `json:"layers"`
		FeatureColl  struct {
			Type     string            `json:"type"`
			Features []json.RawMessage `json:"features"`
		} `json:"feature_collection"`
	}
	if err := json.Unmarshal(rr.Body.Bytes(), &payload); err != nil {
		t.Fatalf("decode response failed: %v", err)
	}
	if payload.SourceFormat != "dxf" {
		t.Fatalf("expected dxf source format, got %s", payload.SourceFormat)
	}
	if len(payload.FeatureColl.Features) == 0 {
		t.Fatalf("expected at least one feature")
	}
}

func TestParseCadFileREST_DWGRejected(t *testing.T) {
	h := NewProjectHandler(nil, zerolog.Nop())
	dwg := []byte("AC1021")

	req, _ := makeMultipartRequest(t, "/api/v1/cad/parse", "file", "client.dwg", dwg)
	rr := httptest.NewRecorder()

	h.ParseCadFileREST(rr, req)

	if rr.Code != http.StatusUnprocessableEntity {
		t.Fatalf("expected 422, got %d body=%s", rr.Code, rr.Body.String())
	}
	var payload map[string]string
	if err := json.Unmarshal(rr.Body.Bytes(), &payload); err != nil {
		t.Fatalf("decode response failed: %v", err)
	}
	if payload["code"] != "dwg_not_supported" {
		t.Fatalf("expected dwg_not_supported code, got %q", payload["code"])
	}
	if payload["dwg_version"] != "AC1021" {
		t.Fatalf("expected AC1021 version, got %q", payload["dwg_version"])
	}
	if !strings.Contains(strings.ToLower(payload["reason"]), "binary") && !strings.Contains(strings.ToLower(payload["reason"]), "dwg") {
		t.Fatalf("expected detailed DWG reason, got %#v", payload)
	}
}

func TestImportSiteBoundaryREST_DWGRejectedEarly(t *testing.T) {
	h := NewProjectHandler(nil, zerolog.Nop())
	dwg := []byte("AC1021")

	projectID := uuid.New().String()
	req, _ := makeMultipartRequest(t, "/api/v1/projects/"+projectID+"/site/import-boundary", "file", "client.dwg", dwg)
	req.SetPathValue("id", projectID)
	rr := httptest.NewRecorder()

	h.ImportSiteBoundaryREST(rr, req)

	if rr.Code != http.StatusUnprocessableEntity {
		t.Fatalf("expected 422, got %d body=%s", rr.Code, rr.Body.String())
	}
	var payload map[string]string
	if err := json.Unmarshal(rr.Body.Bytes(), &payload); err != nil {
		t.Fatalf("decode response failed: %v", err)
	}
	if payload["code"] != "dwg_not_supported" {
		t.Fatalf("expected dwg_not_supported code, got %q", payload["code"])
	}
}

func TestParseCadFileREST_OversizedUploadRejected(t *testing.T) {
	h := NewProjectHandler(nil, zerolog.Nop())
	oversized := bytes.Repeat([]byte("A"), (32<<20)+1024)
	body, contentType := makeMultipartBytes(t, "file", "oversized.dxf", oversized)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/cad/parse", bytes.NewReader(body))
	req.Header.Set("Content-Type", contentType)
	req.ContentLength = int64(len(body))
	rr := httptest.NewRecorder()

	h.ParseCadFileREST(rr, req)

	if rr.Code != http.StatusRequestEntityTooLarge {
		t.Fatalf("expected 413, got %d body=%s", rr.Code, rr.Body.String())
	}
}
