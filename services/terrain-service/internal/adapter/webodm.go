// Package adapter provides HTTP client adapters for external GIS data sources.
package adapter

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// WebODMClient interacts with a WebODM instance to retrieve drone
// orthomosaic processing results.
//
// WebODM API docs: https://docs.webodm.org/
type WebODMClient struct {
	baseURL string
	token   string
	client  *http.Client
}

// WebODMTask represents a processing task on the WebODM server.
type WebODMTask struct {
	ID         string    `json:"id"`
	ProjectID  int       `json:"project"`
	Status     int       `json:"status"` // 10=queued, 20=running, 30=failed, 40=completed
	Name       string    `json:"name"`
	CreatedAt  time.Time `json:"created_at"`
	OrthophotoURL string `json:"orthophoto_url,omitempty"`
	DSMUrl     string    `json:"dsm_url,omitempty"`
	DTMUrl     string    `json:"dtm_url,omitempty"`
}

// NewWebODMClient creates a client for a WebODM instance.
//
// baseURL: e.g., "http://localhost:8000"
// token: API token from WebODM admin panel.
func NewWebODMClient(baseURL, token string) *WebODMClient {
	return &WebODMClient{
		baseURL: baseURL,
		token:   token,
		client:  &http.Client{Timeout: 30 * time.Second},
	}
}

// GetTask retrieves a processing task by ID.
func (c *WebODMClient) GetTask(ctx context.Context, projectID int, taskID string) (*WebODMTask, error) {
	url := fmt.Sprintf("%s/api/projects/%d/tasks/%s/", c.baseURL, projectID, taskID)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("webodm: build request: %w", err)
	}
	req.Header.Set("Authorization", "JWT "+c.token)

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("webodm: http: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return nil, fmt.Errorf("webodm: HTTP %d: %s", resp.StatusCode, string(body))
	}

	var task WebODMTask
	if err := json.NewDecoder(resp.Body).Decode(&task); err != nil {
		return nil, fmt.Errorf("webodm: decode: %w", err)
	}

	// Build download URLs
	if task.Status == 40 { // completed
		task.OrthophotoURL = fmt.Sprintf("%s/api/projects/%d/tasks/%s/download/orthophoto.tif", c.baseURL, projectID, taskID)
		task.DSMUrl = fmt.Sprintf("%s/api/projects/%d/tasks/%s/download/dsm.tif", c.baseURL, projectID, taskID)
		task.DTMUrl = fmt.Sprintf("%s/api/projects/%d/tasks/%s/download/dtm.tif", c.baseURL, projectID, taskID)
	}
	return &task, nil
}

// DownloadAsset downloads a processed asset (orthophoto, DSM, DTM) as raw bytes.
func (c *WebODMClient) DownloadAsset(ctx context.Context, downloadURL string) ([]byte, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, downloadURL, nil)
	if err != nil {
		return nil, fmt.Errorf("webodm: build download request: %w", err)
	}
	req.Header.Set("Authorization", "JWT "+c.token)

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("webodm: download: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("webodm: download HTTP %d", resp.StatusCode)
	}

	data, err := io.ReadAll(io.LimitReader(resp.Body, 500<<20)) // 500 MB limit
	if err != nil {
		return nil, fmt.Errorf("webodm: read download: %w", err)
	}
	return data, nil
}
