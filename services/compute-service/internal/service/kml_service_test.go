package service

import (
	"context"
	"testing"
	"time"

	"solar3d/compute-service/internal/models"
	"solar3d/compute-service/internal/repository"
)

// TestKMLService_UploadKML_Valid tests valid KML upload.
func TestKMLService_UploadKML_Valid(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	fileData := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test</name>
    <Placemark>
      <name>Point</name>
      <Point>
        <coordinates>-122.08,37.42,0</coordinates>
      </Point>
    </Placemark>
  </Document>
</kml>`)

	uploadJobID, err := svc.UploadKML(ctx, fileData, "test.kml", 4326, "proj123", nil)
	if err != nil {
		t.Fatalf("UploadKML failed: %v", err)
	}

	if uploadJobID == "" {
		t.Fatal("uploadJobID is empty")
	}

	// Give async processing time to complete
	time.Sleep(200 * time.Millisecond)

	// Check upload job was created
	job, err := svc.GetUploadStatus(ctx, uploadJobID)
	if err != nil {
		t.Fatalf("GetUploadStatus failed: %v", err)
	}

	if job == nil {
		t.Fatal("Job is nil")
	}

	if job.FileName != "test.kml" {
		t.Fatalf("Expected filename 'test.kml', got '%s'", job.FileName)
	}
}

// TestKMLService_UploadKML_EmptyFile tests upload with empty file data.
func TestKMLService_UploadKML_EmptyFile(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, err := svc.UploadKML(ctx, []byte{}, "test.kml", 4326, "", nil)
	if err == nil {
		t.Fatal("Expected error for empty file")
	}
}

// TestKMLService_UploadKML_NoFileName tests upload without filename.
func TestKMLService_UploadKML_NoFileName(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, err := svc.UploadKML(ctx, []byte("data"), "", 4326, "", nil)
	if err == nil {
		t.Fatal("Expected error for missing filename")
	}
}

// TestKMLService_UploadKML_InvalidFileType tests upload with invalid file extension.
func TestKMLService_UploadKML_InvalidFileType(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, err := svc.UploadKML(ctx, []byte("data"), "test.txt", 4326, "", nil)
	if err == nil {
		t.Fatal("Expected error for invalid file type")
	}
}

// TestKMLService_UploadKML_FileTooLarge tests upload with oversized file.
func TestKMLService_UploadKML_FileTooLarge(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	// 101 MB file
	largeFile := make([]byte, 101*1024*1024)
	_, err := svc.UploadKML(ctx, largeFile, "test.kml", 4326, "", nil)
	if err == nil {
		t.Fatal("Expected error for oversized file")
	}
}

// TestKMLService_GetUploadStatus_NotFound tests status retrieval for non-existent job.
func TestKMLService_GetUploadStatus_NotFound(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, err := svc.GetUploadStatus(ctx, "nonexistent")
	if err == nil {
		t.Fatal("Expected error for non-existent job")
	}
}

// TestKMLService_GetUploadStatus_Empty tests status retrieval with empty job ID.
func TestKMLService_GetUploadStatus_Empty(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, err := svc.GetUploadStatus(ctx, "")
	if err == nil {
		t.Fatal("Expected error for empty job ID")
	}
}

// TestKMLService_ListImportedGeometries tests listing geometries from upload.
func TestKMLService_ListImportedGeometries(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	// Create an upload job
	uploadJobID, _ := repo.CreateUploadJob(ctx, &models.KMLUploadJob{
		FileName: "test.kml",
	})

	// Create sample geometries
	repo.CreateGeometry(ctx, &models.ImportedGeometry{
		UploadJobID:  uploadJobID,
		FeatureName:  "Point 1",
		GeometryType: "Point",
	})

	// List geometries
	geoms, count, err := svc.ListImportedGeometries(ctx, uploadJobID, "", 50, 0)
	if err != nil {
		t.Fatalf("ListImportedGeometries failed: %v", err)
	}

	if count != 1 {
		t.Fatalf("Expected 1 geometry, got %d", count)
	}

	if len(geoms) != 1 {
		t.Fatalf("Expected 1 geometry in response, got %d", len(geoms))
	}
}

// TestKMLService_GetImportedGeometry_Valid tests retrieving single geometry.
func TestKMLService_GetImportedGeometry_Valid(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	// Create geometry
	geomID, _ := repo.CreateGeometry(ctx, &models.ImportedGeometry{
		UploadJobID:  "upload1",
		FeatureName:  "Test Geometry",
		GeometryType: "Point",
	})

	// Retrieve it
	geom, err := svc.GetImportedGeometry(ctx, geomID)
	if err != nil {
		t.Fatalf("GetImportedGeometry failed: %v", err)
	}

	if geom == nil {
		t.Fatal("Geometry is nil")
	}

	if geom.FeatureName != "Test Geometry" {
		t.Fatalf("Expected 'Test Geometry', got '%s'", geom.FeatureName)
	}
}

// TestKMLService_DeleteUpload tests deletion of upload and geometries.
func TestKMLService_DeleteUpload(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	// Create upload and geometry
	uploadJobID, _ := repo.CreateUploadJob(ctx, &models.KMLUploadJob{
		FileName: "test.kml",
	})

	repo.CreateGeometry(ctx, &models.ImportedGeometry{
		UploadJobID: uploadJobID,
	})

	// Delete upload
	count, err := svc.DeleteUpload(ctx, uploadJobID)
	if err != nil {
		t.Fatalf("DeleteUpload failed: %v", err)
	}

	if count != 1 {
		t.Fatalf("Expected 1 geometry deleted, got %d", count)
	}
}

// TestKMLService_UploadKML_KMZ tests KMZ file handling.
func TestKMLService_UploadKML_KMZ(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	// Create a minimal KML content
	kmlContent := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test</name>
    <Placemark>
      <name>Point</name>
      <Point><coordinates>0,0,0</coordinates></Point>
    </Placemark>
  </Document>
</kml>`)

	// Note: For KMZ testing, would need to create ZIP file
	// This test just verifies filename validation
	uploadJobID, err := svc.UploadKML(ctx, kmlContent, "test.kmz", 4326, "", nil)
	if err != nil {
		t.Fatalf("UploadKML failed for KMZ: %v", err)
	}

	if uploadJobID == "" {
		t.Fatal("uploadJobID is empty for KMZ")
	}
}

// TestKMLService_ListImportedGeometries_InvalidJobID tests listing with invalid job ID.
func TestKMLService_ListImportedGeometries_InvalidJobID(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, _, err := svc.ListImportedGeometries(ctx, "", "", 50, 0)
	if err == nil {
		t.Fatal("Expected error for empty job ID")
	}
}

// TestKMLService_GetImportedGeometry_InvalidID tests retrieval with invalid geometry ID.
func TestKMLService_GetImportedGeometry_InvalidID(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, err := svc.GetImportedGeometry(ctx, "")
	if err == nil {
		t.Fatal("Expected error for empty geometry ID")
	}
}

// TestKMLService_DeleteUpload_InvalidID tests deletion with invalid job ID.
func TestKMLService_DeleteUpload_InvalidID(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	_, err := svc.DeleteUpload(ctx, "")
	if err == nil {
		t.Fatal("Expected error for empty job ID")
	}
}

// TestKMLService_UploadKML_WithMetadata tests upload with project ID and tags.
func TestKMLService_UploadKML_WithMetadata(t *testing.T) {
	repo := repository.NewMockKMLRepository()
	svc := NewKMLService(repo)
	ctx := context.Background()

	fileData := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document><name>Test</name></Document>
</kml>`)

	tags := map[string]string{
		"source": "survey",
		"date":   "2026-04-04",
	}

	uploadJobID, err := svc.UploadKML(ctx, fileData, "test.kml", 4326, "proj456", tags)
	if err != nil {
		t.Fatalf("UploadKML with metadata failed: %v", err)
	}

	if uploadJobID == "" {
		t.Fatal("uploadJobID is empty")
	}

	// Verify metadata was stored
	job, _ := repo.GetUploadJob(ctx, uploadJobID)
	if job.ProjectID != "proj456" {
		t.Fatalf("Expected project ID 'proj456', got '%s'", job.ProjectID)
	}

	if job.Tags["source"] != "survey" {
		t.Fatal("Tags not properly stored")
	}
}
