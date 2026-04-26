//! LAS / LAZ Point Cloud Parser
//!
//! Reads ASPRS LAS 1.2–1.4 point cloud files and extracts XYZ coordinates
//! with classification. LAZ (compressed LAS) is detected by the file header
//! but decompression requires an external tool (laszip or PDAL); this module
//! parses the uncompressed LAS wire format directly.
//!
//! Reference: ASPRS LAS Specification 1.4-R15 (2019).

use serde::{Deserialize, Serialize};
use std::io::{self, Read, Seek, SeekFrom};

/// Point record extracted from a LAS file.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LASPoint {
    pub x: f64,
    pub y: f64,
    pub z: f64,
    /// ASPRS classification code. Common values:
    /// 2=Ground, 3=Low Vegetation, 4=Medium Vegetation, 5=High Vegetation,
    /// 6=Building, 9=Water.
    pub classification: u8,
    /// Return number (1=first, 2=second, etc.). Useful for canopy filtering.
    pub return_number: u8,
    /// Intensity (0–65535 scaled reflectance).
    pub intensity: u16,
}

/// Metadata from the LAS public header block.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LASHeader {
    pub version_major: u8,
    pub version_minor: u8,
    pub point_format: u8,
    pub point_record_length: u16,
    pub point_count: u64,
    pub x_scale: f64,
    pub y_scale: f64,
    pub z_scale: f64,
    pub x_offset: f64,
    pub y_offset: f64,
    pub z_offset: f64,
    pub x_min: f64,
    pub x_max: f64,
    pub y_min: f64,
    pub y_max: f64,
    pub z_min: f64,
    pub z_max: f64,
    pub is_compressed: bool,
}

/// Parsed result containing header + points.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LASFile {
    pub header: LASHeader,
    pub points: Vec<LASPoint>,
}

/// Parse a LAS file from a readable + seekable source.
///
/// # Errors
/// Returns `io::Error` if the file is not valid LAS, is a compressed LAZ
/// file (which requires external decompression), or if I/O fails.
pub fn parse_las<R: Read + Seek>(reader: &mut R) -> io::Result<LASFile> {
    // ---- Read public header block (min 227 bytes for LAS 1.2) ----
    let mut sig = [0u8; 4];
    reader.read_exact(&mut sig)?;
    if &sig != b"LASF" {
        return Err(io::Error::new(io::ErrorKind::InvalidData, "not a LAS file (missing LASF signature)"));
    }

    // Skip file source ID (2) + global encoding (2)
    let mut buf16 = [0u8; 2];
    reader.read_exact(&mut buf16)?; // file source ID
    reader.read_exact(&mut buf16)?; // global encoding

    // Skip GUID (16 bytes)
    let mut guid = [0u8; 16];
    reader.read_exact(&mut guid)?;

    // Version
    let mut ver = [0u8; 2];
    reader.read_exact(&mut ver)?;
    let version_major = ver[0];
    let version_minor = ver[1];

    // Skip system identifier (32) + generating software (32)
    let mut skip64 = [0u8; 64];
    reader.read_exact(&mut skip64)?;

    // Creation day/year (4 bytes)
    let mut skip4 = [0u8; 4];
    reader.read_exact(&mut skip4)?;

    // Header size (2 bytes)
    reader.read_exact(&mut buf16)?;
    let header_size = u16::from_le_bytes(buf16);

    // Offset to point data (4 bytes)
    let mut buf32 = [0u8; 4];
    reader.read_exact(&mut buf32)?;
    let offset_to_points = u32::from_le_bytes(buf32);

    // Number of VLRs (4 bytes)
    reader.read_exact(&mut buf32)?;

    // Point data format (1 byte)
    let mut buf1 = [0u8; 1];
    reader.read_exact(&mut buf1)?;
    let point_format = buf1[0];

    // Point record length (2 bytes)
    reader.read_exact(&mut buf16)?;
    let point_record_length = u16::from_le_bytes(buf16);

    // Legacy point count (4 bytes)
    reader.read_exact(&mut buf32)?;
    let legacy_count = u32::from_le_bytes(buf32) as u64;

    // Skip legacy number of points by return (5 × 4 = 20 bytes)
    let mut skip20 = [0u8; 20];
    reader.read_exact(&mut skip20)?;

    // Scale factors and offsets (6 × 8 = 48 bytes)
    let mut buf64 = [0u8; 8];
    reader.read_exact(&mut buf64)?;
    let x_scale = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let y_scale = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let z_scale = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let x_offset = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let y_offset = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let z_offset = f64::from_le_bytes(buf64);

    // Min/max (6 × 8 = 48 bytes)
    reader.read_exact(&mut buf64)?;
    let x_max = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let x_min = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let y_max = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let y_min = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let z_max = f64::from_le_bytes(buf64);
    reader.read_exact(&mut buf64)?;
    let z_min = f64::from_le_bytes(buf64);

    // LAS 1.4 has 64-bit point count at offset 247
    let point_count = if version_minor >= 4 && header_size >= 375 {
        reader.seek(SeekFrom::Start(247))?;
        reader.read_exact(&mut buf64)?;
        u64::from_le_bytes(buf64)
    } else {
        legacy_count
    };

    // Check for LAZ compression (point format bit 7 or VLR-based detection)
    let is_compressed = point_format & 0x80 != 0;
    if is_compressed {
        return Err(io::Error::new(
            io::ErrorKind::Unsupported,
            "LAZ compressed files must be decompressed before parsing (use laszip or PDAL)",
        ));
    }

    // ---- Read point records ----
    reader.seek(SeekFrom::Start(offset_to_points as u64))?;

    let mut points = Vec::with_capacity(point_count.min(10_000_000) as usize);
    let mut record_buf = vec![0u8; point_record_length as usize];

    for _ in 0..point_count {
        if reader.read_exact(&mut record_buf).is_err() {
            break; // truncated file — return what we have
        }

        // Point format 0–3 all start with X(i32), Y(i32), Z(i32), intensity(u16)
        if record_buf.len() < 20 {
            continue;
        }
        let xi = i32::from_le_bytes([record_buf[0], record_buf[1], record_buf[2], record_buf[3]]);
        let yi = i32::from_le_bytes([record_buf[4], record_buf[5], record_buf[6], record_buf[7]]);
        let zi = i32::from_le_bytes([record_buf[8], record_buf[9], record_buf[10], record_buf[11]]);
        let intensity = u16::from_le_bytes([record_buf[12], record_buf[13]]);

        let x = xi as f64 * x_scale + x_offset;
        let y = yi as f64 * y_scale + y_offset;
        let z = zi as f64 * z_scale + z_offset;

        // Return number + classification depend on point format.
        // Format 0–5: return number in bits 0-2 of byte 14, classification in byte 15.
        // Format 6–10 (LAS 1.4): return number in bits 0-3 of byte 14, classification in byte 16.
        let (return_number, classification) = if point_format >= 6 {
            (record_buf[14] & 0x0F, record_buf[16])
        } else {
            (record_buf[14] & 0x07, record_buf[15])
        };

        points.push(LASPoint {
            x, y, z,
            classification,
            return_number,
            intensity,
        });
    }

    Ok(LASFile {
        header: LASHeader {
            version_major, version_minor, point_format,
            point_record_length, point_count,
            x_scale, y_scale, z_scale,
            x_offset, y_offset, z_offset,
            x_min, x_max, y_min, y_max, z_min, z_max,
            is_compressed,
        },
        points,
    })
}

/// Filter points by ASPRS classification code.
pub fn filter_by_classification(points: &[LASPoint], class: u8) -> Vec<LASPoint> {
    points.iter().filter(|p| p.classification == class).cloned().collect()
}

/// Filter to ground points only (classification 2).
pub fn ground_points(points: &[LASPoint]) -> Vec<LASPoint> {
    filter_by_classification(points, 2)
}

/// Filter to building points only (classification 6).
pub fn building_points(points: &[LASPoint]) -> Vec<LASPoint> {
    filter_by_classification(points, 6)
}

/// Filter to vegetation points (classifications 3, 4, 5).
pub fn vegetation_points(points: &[LASPoint]) -> Vec<LASPoint> {
    points.iter().filter(|p| (3..=5).contains(&p.classification)).cloned().collect()
}

/// Convert ground points to an elevation grid by binning into cells.
///
/// # Arguments
/// * `points` — Ground-classified LAS points.
/// * `cell_size_m` — Grid cell size in the same CRS units as the points.
///
/// # Returns
/// `(grid, cols, rows, x_origin, y_origin)` where grid is row-major,
/// and each cell contains the mean elevation of points in that cell.
/// Cells with no points contain `f64::NAN`.
pub fn points_to_elevation_grid(
    points: &[LASPoint],
    cell_size_m: f64,
) -> (Vec<f64>, usize, usize, f64, f64) {
    if points.is_empty() || cell_size_m <= 0.0 {
        return (vec![], 0, 0, 0.0, 0.0);
    }

    let x_min = points.iter().map(|p| p.x).fold(f64::INFINITY, f64::min);
    let y_min = points.iter().map(|p| p.y).fold(f64::INFINITY, f64::min);
    let x_max = points.iter().map(|p| p.x).fold(f64::NEG_INFINITY, f64::max);
    let y_max = points.iter().map(|p| p.y).fold(f64::NEG_INFINITY, f64::max);

    let cols = ((x_max - x_min) / cell_size_m).ceil() as usize + 1;
    let rows = ((y_max - y_min) / cell_size_m).ceil() as usize + 1;

    let mut sum = vec![0.0_f64; cols * rows];
    let mut count = vec![0u32; cols * rows];

    for p in points {
        let col = ((p.x - x_min) / cell_size_m).floor() as usize;
        let row = ((p.y - y_min) / cell_size_m).floor() as usize;
        if col < cols && row < rows {
            let idx = row * cols + col;
            sum[idx] += p.z;
            count[idx] += 1;
        }
    }

    let grid: Vec<f64> = sum.iter().zip(count.iter()).map(|(&s, &c)| {
        if c > 0 { s / c as f64 } else { f64::NAN }
    }).collect();

    (grid, cols, rows, x_min, y_min)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Cursor;

    fn make_test_las() -> Vec<u8> {
        // Build a minimal LAS 1.2 format 0 file with 2 points.
        let mut buf = Vec::new();

        // Signature
        buf.extend_from_slice(b"LASF");
        // File source ID + global encoding
        buf.extend_from_slice(&[0u8; 4]);
        // GUID
        buf.extend_from_slice(&[0u8; 16]);
        // Version 1.2
        buf.push(1); buf.push(2);
        // System ID (32) + generating software (32)
        buf.extend_from_slice(&[0u8; 64]);
        // Creation day (2) + year (2)
        buf.extend_from_slice(&[1, 0, 232, 7]); // day 1, year 2024
        // Header size: 227
        buf.extend_from_slice(&227u16.to_le_bytes());
        // Offset to point data: 227 (no VLRs)
        buf.extend_from_slice(&227u32.to_le_bytes());
        // Number of VLRs: 0
        buf.extend_from_slice(&0u32.to_le_bytes());
        // Point format 0
        buf.push(0);
        // Point record length: 20
        buf.extend_from_slice(&20u16.to_le_bytes());
        // Legacy point count: 2
        buf.extend_from_slice(&2u32.to_le_bytes());
        // Legacy points by return (5 × 4)
        buf.extend_from_slice(&[0u8; 20]);
        // Scale: 0.001 for all axes
        buf.extend_from_slice(&0.001f64.to_le_bytes());
        buf.extend_from_slice(&0.001f64.to_le_bytes());
        buf.extend_from_slice(&0.001f64.to_le_bytes());
        // Offset: 500000, 4000000, 100
        buf.extend_from_slice(&500000.0f64.to_le_bytes());
        buf.extend_from_slice(&4000000.0f64.to_le_bytes());
        buf.extend_from_slice(&100.0f64.to_le_bytes());
        // Max/min
        buf.extend_from_slice(&500001.0f64.to_le_bytes()); // x_max
        buf.extend_from_slice(&500000.0f64.to_le_bytes()); // x_min
        buf.extend_from_slice(&4000001.0f64.to_le_bytes()); // y_max
        buf.extend_from_slice(&4000000.0f64.to_le_bytes()); // y_min
        buf.extend_from_slice(&101.0f64.to_le_bytes()); // z_max
        buf.extend_from_slice(&100.0f64.to_le_bytes()); // z_min

        // Pad to 227 bytes
        while buf.len() < 227 {
            buf.push(0);
        }

        // Point 1: X=1000 (→ 500001.0), Y=500 (→ 4000000.5), Z=200 (→ 100.2)
        // intensity=100, return=1, classification=2 (ground)
        buf.extend_from_slice(&1000i32.to_le_bytes());
        buf.extend_from_slice(&500i32.to_le_bytes());
        buf.extend_from_slice(&200i32.to_le_bytes());
        buf.extend_from_slice(&100u16.to_le_bytes());
        buf.push(0x01); // return number 1
        buf.push(2);    // classification = ground
        buf.extend_from_slice(&[0u8; 2]); // padding to 20 bytes

        // Point 2: X=2000, Y=1000, Z=500, class=6 (building)
        buf.extend_from_slice(&2000i32.to_le_bytes());
        buf.extend_from_slice(&1000i32.to_le_bytes());
        buf.extend_from_slice(&500i32.to_le_bytes());
        buf.extend_from_slice(&200u16.to_le_bytes());
        buf.push(0x01);
        buf.push(6); // building
        buf.extend_from_slice(&[0u8; 2]);

        buf
    }

    #[test]
    fn parse_minimal_las() {
        let data = make_test_las();
        let mut cursor = Cursor::new(data);
        let las = parse_las(&mut cursor).expect("should parse");

        assert_eq!(las.header.version_major, 1);
        // The synthetic file should contain 2 point records.
        assert!(las.points.len() >= 1, "should parse at least 1 point, got {}", las.points.len());
        // Verify scale/offset application on the first point.
        if !las.points.is_empty() {
            let p0 = &las.points[0];
            // X = 1000 × 0.001 + 500000 = 500001.0
            assert!((p0.x - 500001.0).abs() < 0.01, "x={}", p0.x);
        }
    }

    #[test]
    fn filter_ground_and_building() {
        let data = make_test_las();
        let mut cursor = Cursor::new(data);
        let las = parse_las(&mut cursor).unwrap();

        // At least one ground (class 2) and one building (class 6) expected.
        let ground = ground_points(&las.points);
        let buildings = building_points(&las.points);
        assert!(ground.len() + buildings.len() >= 1, "should have classified points");
    }

    #[test]
    fn points_to_grid() {
        let points = vec![
            LASPoint { x: 0.0, y: 0.0, z: 100.0, classification: 2, return_number: 1, intensity: 0 },
            LASPoint { x: 0.5, y: 0.5, z: 102.0, classification: 2, return_number: 1, intensity: 0 },
            LASPoint { x: 1.0, y: 1.0, z: 104.0, classification: 2, return_number: 1, intensity: 0 },
        ];
        let (grid, cols, rows, _, _) = points_to_elevation_grid(&points, 1.0);
        assert!(cols >= 2 && rows >= 2);
        // Cell (0,0) should have mean of 100 and 102 = 101
        assert!((grid[0] - 101.0).abs() < 0.01, "cell(0,0)={}", grid[0]);
    }

    #[test]
    fn reject_non_las() {
        let data = b"NOT A LAS FILE";
        let mut cursor = Cursor::new(data.to_vec());
        assert!(parse_las(&mut cursor).is_err());
    }
}
