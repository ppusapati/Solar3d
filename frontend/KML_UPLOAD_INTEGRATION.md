# KML Upload Frontend Integration Guide

## Overview
The KML upload component provides a production-ready, user-friendly interface for importing geographic data in KML/KMZ format. It's built with Svelte + Tailwind CSS and integrates with the gRPC KMLIngestionService backend.

## Components

### 1. **KMLUpload.svelte** (`frontend/src/components/KMLUpload.svelte`)
Main upload component with drag-drop, progress tracking, and result display.

**Features:**
- Drag-and-drop file upload
- File input alternative (fallback)
- Real-time progress bar (10-90% during processing)
- Status polling (500ms intervals)
- Geometry list display with type icons (📍📏🔷🔶)
- Error handling with user-friendly messages
- File size validation (100MB limit)
- File type validation (.kml, .kmz)
- Result summary showing import counts

**Props:** None (internal state management)

**Stores:** None (component-level state)

**Export States:**
```typescript
// Upload not started (UI shows drag-drop area)
files === null && uploadJob === null && !isUploading

// Uploading (shows progress bar)
isUploading && uploadJob?.status === 'PROCESSING'

// Completed (shows geometry list and summary)
uploadJob?.status === 'COMPLETED'

// Failed (shows error message and retry button)
uploadJob?.status === 'FAILED' || uploadError !== null
```

### 2. **+page.svelte** (`frontend/src/routes/import/+page.svelte`)
Full page layout with upload component and information panels.

**Features:**
- Dark theme background (gradient)
- Responsive two-column layout (mobile: single column)
- Upload component in main column
- Info panels covering:
  - Supported file formats (KML, KMZ)
  - Geometry types (Point, LineString, Polygon, MultiPolygon)
  - Coordinate systems (70+ EPSG codes)
  - Processing pipeline steps (5 stages)
  - System limits and constraints

**Route:** `/import`

## Integration Setup

### 1. **Environment Configuration**

Create or update `.env.local`:
```env
PUBLIC_API_ENDPOINT=http://localhost:50054
PUBLIC_MAX_FILE_SIZE=104857600
PUBLIC_POLL_INTERVAL=500
```

Update component constants:
```typescript
const API_ENDPOINT = 'http://localhost:50054'; // compute-service gRPC endpoint
const MAX_FILE_SIZE = 100 * 1024 * 1024; // 100MB
const POLL_INTERVAL = 500; // 500ms status polling
```

### 2. **gRPC Service Configuration**

The component connects to `localhost:50054` (compute-service default port).

**Endpoints Called:**
- `POST /kml.v1.KMLIngestionService/UploadKML`
- `POST /kml.v1.KMLIngestionService/GetUploadStatus`
- `POST /kml.v1.KMLIngestionService/ListImportedGeometries`

**Request/Response Format:**

**UploadKML Request:**
```json
{
  "fileData": [<uint8 array>],
  "fileName": "example.kml",
  "sourceCrs": 4326,
  "tags": {
    "source": "web-upload",
    "uploadDate": "2026-04-04"
  }
}
```

**UploadKML Response:**
```json
{
  "uploadJobId": "uuid-string",
  "fileName": "example.kml",
  "status": "PROCESSING",
  "featuresProcessed": 0,
  "totalFeatures": 25,
  "createdAt": "2026-04-04T10:30:00Z"
}
```

**GetUploadStatus Request:**
```json
{
  "uploadJobId": "uuid-string"
}
```

**GetUploadStatus Response:**
```json
{
  "uploadJobId": "uuid-string",
  "fileName": "example.kml",
  "status": "COMPLETED",
  "featuresProcessed": 25,
  "totalFeatures": 25,
  "completedAt": "2026-04-04T10:31:45Z"
}
```

**ListImportedGeometries Request:**
```json
{
  "uploadJobId": "uuid-string",
  "limit": 100,
  "offset": 0
}
```

**ListImportedGeometries Response:**
```json
{
  "geometries": [
    {
      "geometryId": "uuid1",
      "name": "Solar Field North",
      "type": "POLYGON",
      "boundingBox": {
        "minX": -118.5,
        "minY": 35.2,
        "maxX": -118.4,
        "maxY": 35.3
      }
    }
  ],
  "total": 1
}
```

### 3. **Using the Component**

Import in a Svelte page:
```svelte
<script>
  import KMLUpload from '../components/KMLUpload.svelte';
</script>

<div class="container">
  <KMLUpload />
</div>
```

Or use the full import page:
```
Route: /import
File: frontend/src/routes/import/+page.svelte
```

## Styling & Customization

**Tailwind Classes Used:**
- Layout: `grid`, `max-w-`, `gap-`, `flex`, `space-y-`
- Typography: `text-`, `font-bold`, `capitalize`
- Colors: `bg-blue-`, `text-gray-`, `border-`
- Transitions: `transition`, `duration-`
- Responsive: `md:`, `mobile-first`

**Customize Colors:**
- Primary: `bg-blue-500` → Change to `bg-green-500`, etc.
- Error: `bg-red-50` → Modify red color scheme
- Success: `bg-green-50` → Modify green scheme

**Dark Mode:**
Currently light theme. Add dark mode variants:
```svelte
class="dark:bg-gray-800 dark:text-white"
```

## Error Handling

### Validation Errors
```typescript
// File type error
"File must be KML or KMZ format"

// File size error
"File size exceeds 100MB limit (120.50MB)"

// Upload error (from backend)
// Example: "Invalid geometry in feature #3"
```

### Status Codes (from backend)
- **400**: InvalidArgument (validation failed)
- **404**: NotFound (job not found)
- **500**: Internal (server error)

## Performance Considerations

1. **File Upload**: Binary file sent as byte array in JSON (base64-like format)
   - 100MB file = potentially large payload
   - Consider chunked upload for very large files (future enhancement)

2. **Status Polling**: 500ms interval balance between responsiveness and load
   - Adjust `POLL_INTERVAL` constant if needed
   - Stop polling immediately on completion/failure

3. **Geometry List**: Limited to 100 items per request (configurable via `limit` param)
   - Implement pagination if >100 geometries per upload

## Testing

### Unit Test Example (Jest/Vitest)
```typescript
import { render, screen } from '@testing-library/svelte';
import KMLUpload from './KMLUpload.svelte';

test('displays drag-drop area', () => {
  render(KMLUpload);
  expect(screen.getByText(/drag and drop/i)).toBeInTheDocument();
});
```

### E2E Test Example (Playwright)
```typescript
test('uploads KML file and shows results', async ({ page }) => {
  await page.goto('/import');
  await page.setInputFiles('input[type="file"]', 'test.kml');
  await page.waitForSelector('.success-message');
  expect(page.locator('text=Upload Successful')).toBeVisible();
});
```

## Accessibility

- ✅ Semantic HTML (`<div role="presentation">` for drag area)
- ✅ Keyboard navigation (file input focus)
- ✅ Color contrast (WCAG AA compliant)
- ✅ Error messages announced to screen readers
- ✅ Progress bar with aria-* attributes (future enhancement)

**Improvements Needed:**
- Add `aria-label` to progress bar
- Add `aria-live` regions for status updates
- Add `aria-describedby` for error messages

## Deployment

### Production Checklist
- [ ] Build Svelte component: `npm run build`
- [ ] Test in staging environment
- [ ] Verify gRPC endpoint connectivity
- [ ] Check CORS settings (if applicable)
- [ ] Monitor error logs in first 24h
- [ ] Gather user feedback on UX

### Build Configuration (vite.config.ts)
Ensure Tailwind is configured:
```typescript
export default {
  // ... existing config
  css: {
    postcss: './postcss.config.js'
  }
}
```

## Future Enhancements

1. **Chunked Upload**: Handle files >500MB
2. **Geometry Preview**: Render imported geometries on map
3. **Batch Upload**: Upload multiple files in parallel
4. **Import Scheduling**: Schedule imports for off-peak hours
5. **Data Mapping**: Allow user to map KML properties to database fields
6. **Undo/Rollback**: Delete imported geometries or entire upload jobs
7. **Export**: Export imported geometries to GeoJSON, Shapefile, etc.

## Troubleshooting

### Upload seems stuck
- Check browser console for errors
- Verify compute-service is running on port 50054
- Check event listener for "COMPLETED" status update

### Geometries not showing after upload
- Verify `ListImportedGeometries` response format
- Check `importedGeometries` array population logic
- Review browser Network tab for API responses

### File too large error
- Check `MAX_FILE_SIZE` constant (currently 100MB)
- Verify file is <100MB or adjust constant

### CORS errors
- Ensure compute-service includes proper CORS headers
- Test with curl: `curl -H "Origin: http://localhost:5173"`

## Support & Maintenance

**Maintained By:** Solar3D Platform Team

**Last Updated:** 2026-04-04

**Related Files:**
- Backend: `internal/handler/kml.go`
- Proto: `proto/kml/v1/kml_ingestion.proto`
- Database: `migrations/015_kml_ingestion.sql`
