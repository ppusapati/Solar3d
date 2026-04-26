//! PV System Diagram Generation (SVG)
//!
//! Generates single-line diagrams (SLD), three-line diagrams (3LD), stringing
//! diagrams, combiner schematics, AC collection diagrams, and SCADA
//! architecture diagrams as SVG strings.

use serde::{Deserialize, Serialize};
use std::fmt::Write;

// ========================================================================
// 1. Single-Line Diagram (SLD)
// ========================================================================

/// PV system topology for SLD generation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SLDInput {
    pub project_name: String,
    pub strings_per_inverter: u32,
    pub modules_per_string: u32,
    pub num_inverters: u32,
    pub inverter_model: String,
    pub inverter_ac_kw: f64,
    pub module_model: String,
    pub module_wp: f64,
    pub transformer_kva: f64,
    pub transformer_primary_v: f64,
    pub transformer_secondary_v: f64,
    pub poi_voltage_kv: f64,
    pub has_meter: bool,
    pub has_disconnect: bool,
}

/// Generate a single-line diagram as SVG.
pub fn generate_sld(input: &SLDInput) -> String {
    let mut svg = String::with_capacity(8192);
    let w = 1200.0_f64;
    let h = 800.0_f64;

    write!(svg, r##"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" font-family="Arial, sans-serif" font-size="11">"##).unwrap();
    write!(svg, r##"<rect width="{w}" height="{h}" fill="white"/>"##).unwrap();

    // Title block
    write!(svg, r##"<text x="600" y="30" text-anchor="middle" font-size="16" font-weight="bold">{} — Single-Line Diagram</text>"##, input.project_name).unwrap();

    let total_dc_kw = input.num_inverters as f64 * input.strings_per_inverter as f64
        * input.modules_per_string as f64 * input.module_wp / 1000.0;
    write!(svg, r##"<text x="600" y="50" text-anchor="middle" font-size="12">DC: {:.0} kWp | AC: {:.0} kW | DC/AC: {:.2}</text>"##,
        total_dc_kw, input.num_inverters as f64 * input.inverter_ac_kw,
        total_dc_kw / (input.num_inverters as f64 * input.inverter_ac_kw).max(1.0)
    ).unwrap();

    // Draw components left to right: PV Array → Combiner → Inverter → Transformer → Meter → POI
    let y_mid = 400.0;
    let mut x = 80.0;

    // PV Array symbol
    svg_pv_array(&mut svg, x, y_mid - 60.0, input.modules_per_string, input.strings_per_inverter);
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="10">{} × {} Wp</text>"##,
        x + 40.0, y_mid + 70.0, input.modules_per_string * input.strings_per_inverter, input.module_wp
    ).unwrap();
    x += 120.0;

    // Line to combiner
    svg_line(&mut svg, x - 40.0, y_mid, x, y_mid);

    // Combiner box
    svg_box(&mut svg, x, y_mid - 20.0, 60.0, 40.0, "Combiner");
    x += 100.0;
    svg_line(&mut svg, x - 40.0, y_mid, x, y_mid);

    // DC disconnect
    svg_disconnect(&mut svg, x, y_mid, "DC\nDisc.");
    x += 80.0;
    svg_line(&mut svg, x - 40.0, y_mid, x, y_mid);

    // Inverter
    svg_inverter(&mut svg, x, y_mid - 25.0, &input.inverter_model, input.inverter_ac_kw);
    x += 120.0;
    svg_line(&mut svg, x - 40.0, y_mid, x, y_mid);

    // AC disconnect
    if input.has_disconnect {
        svg_disconnect(&mut svg, x, y_mid, "AC\nDisc.");
        x += 80.0;
        svg_line(&mut svg, x - 40.0, y_mid, x, y_mid);
    }

    // Transformer
    svg_transformer(&mut svg, x, y_mid - 25.0, input.transformer_kva,
        input.transformer_secondary_v, input.transformer_primary_v);
    x += 120.0;
    svg_line(&mut svg, x - 40.0, y_mid, x, y_mid);

    // Meter
    if input.has_meter {
        svg_meter(&mut svg, x, y_mid);
        x += 80.0;
        svg_line(&mut svg, x - 40.0, y_mid, x, y_mid);
    }

    // POI
    svg_poi(&mut svg, x, y_mid, input.poi_voltage_kv);

    // Legend
    write!(svg, r##"<text x="20" y="{}" font-size="9" fill="#666">Inverter: {} × {} | Transformer: {:.0} kVA {:.0}V/{:.0}V | POI: {:.1} kV</text>"##,
        h - 20.0, input.num_inverters, input.inverter_model,
        input.transformer_kva, input.transformer_secondary_v, input.transformer_primary_v,
        input.poi_voltage_kv
    ).unwrap();

    svg.push_str("</svg>");
    svg
}

// ========================================================================
// 2. Three-Line Diagram (3LD)
// ========================================================================

/// Generate a three-line diagram showing all three phases.
pub fn generate_3ld(input: &SLDInput) -> String {
    let mut svg = String::with_capacity(12000);
    let w = 1400.0;
    let h = 600.0;

    write!(svg, r##"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" font-family="Arial, sans-serif" font-size="11">"##).unwrap();
    write!(svg, r##"<rect width="{w}" height="{h}" fill="white"/>"##).unwrap();
    write!(svg, r##"<text x="700" y="30" text-anchor="middle" font-size="16" font-weight="bold">{} — Three-Line Diagram</text>"##, input.project_name).unwrap();

    let phases = ["A (L1)", "B (L2)", "C (L3)"];
    let colors = ["#d32f2f", "#1976d2", "#388e3c"]; // red, blue, green
    let y_start = 120.0;
    let y_spacing = 140.0;

    for (i, (phase, color)) in phases.iter().zip(colors.iter()).enumerate() {
        let y = y_start + i as f64 * y_spacing;
        let mut x = 100.0;

        // Phase label
        write!(svg, r##"<text x="40" y="{}" fill="{}" font-weight="bold">{}</text>"##, y + 5.0, color, phase).unwrap();

        // Inverter output
        svg_line_colored(&mut svg, x, y, x + 100.0, y, color);
        x += 100.0;

        // AC breaker
        svg_breaker(&mut svg, x, y, color);
        x += 60.0;
        svg_line_colored(&mut svg, x, y, x + 80.0, y, color);
        x += 80.0;

        // Transformer winding
        svg_winding(&mut svg, x, y, color);
        x += 60.0;
        svg_line_colored(&mut svg, x, y, x + 80.0, y, color);
        x += 80.0;

        // MV switchgear
        svg_breaker(&mut svg, x, y, color);
        x += 60.0;
        svg_line_colored(&mut svg, x, y, x + 80.0, y, color);
        x += 80.0;

        // Meter
        write!(svg, r##"<circle cx="{}" cy="{}" r="12" fill="none" stroke="{}" stroke-width="2"/>"##, x, y, color).unwrap();
        write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" fill="{}" font-size="8">kWh</text>"##, x, y + 4.0, color).unwrap();
        x += 40.0;
        svg_line_colored(&mut svg, x - 12.0, y, x + 40.0, y, color);
        x += 40.0;

        // POI bus
        write!(svg, r##"<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="{}" stroke-width="3"/>"##, x, y - 20.0, x, y + 20.0, color).unwrap();
    }

    // Neutral + ground
    let y_n = y_start + 3.0 * y_spacing;
    write!(svg, r##"<text x="40" y="{}" fill="#666">N</text>"##, y_n + 5.0).unwrap();
    svg_line_colored(&mut svg, 100.0, y_n, 800.0, y_n, "#666");
    write!(svg, r##"<text x="40" y="{}" fill="#795548">PE</text>"##, y_n + 35.0).unwrap();
    svg_line_colored(&mut svg, 100.0, y_n + 30.0, 800.0, y_n + 30.0, "#795548");

    svg.push_str("</svg>");
    svg
}

// ========================================================================
// 3. Stringing Diagram
// ========================================================================

/// MPPT-to-module mapping for stringing diagram.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StringMapping {
    pub mppt_id: u32,
    pub string_id: u32,
    pub module_ids: Vec<String>,
}

/// Generate a stringing diagram showing MPPT → string → module connections.
pub fn generate_stringing_diagram(
    project_name: &str,
    inverter_model: &str,
    mappings: &[StringMapping],
) -> String {
    let mut svg = String::with_capacity(16000);
    let row_height = 30.0;
    let h = 100.0 + mappings.len() as f64 * row_height;
    let w = 1200.0;

    write!(svg, r##"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" font-family="monospace" font-size="10">"##).unwrap();
    write!(svg, r##"<rect width="{w}" height="{h}" fill="white"/>"##).unwrap();
    write!(svg, r##"<text x="600" y="25" text-anchor="middle" font-size="14" font-weight="bold" font-family="Arial">{project_name} — Stringing Diagram</text>"##).unwrap();
    write!(svg, r##"<text x="600" y="45" text-anchor="middle" font-size="11" font-family="Arial">Inverter: {inverter_model}</text>"##).unwrap();

    // Column headers
    let y_header = 70.0;
    write!(svg, r##"<text x="50" y="{y_header}" font-weight="bold">MPPT</text>"##).unwrap();
    write!(svg, r##"<text x="120" y="{y_header}" font-weight="bold">String</text>"##).unwrap();
    write!(svg, r##"<text x="200" y="{y_header}" font-weight="bold">Modules (series connection)</text>"##).unwrap();
    write!(svg, r##"<line x1="30" y1="{}" x2="{}" y2="{}" stroke="#ccc"/>"##, y_header + 5.0, w - 30.0, y_header + 5.0).unwrap();

    for (i, m) in mappings.iter().enumerate() {
        let y = y_header + 20.0 + i as f64 * row_height;
        write!(svg, r##"<text x="60" y="{y}">MPPT-{}</text>"##, m.mppt_id).unwrap();
        write!(svg, r##"<text x="130" y="{y}">S{}</text>"##, m.string_id).unwrap();

        let modules_str = m.module_ids.join(" → ");
        write!(svg, r##"<text x="200" y="{y}">{modules_str}</text>"##).unwrap();
    }

    svg.push_str("</svg>");
    svg
}

// ========================================================================
// 4–6. Combiner, AC Collection, SCADA diagrams
// ========================================================================

/// Generate a combiner box schematic showing fused string inputs.
pub fn generate_combiner_schematic(
    combiner_id: &str,
    num_inputs: u32,
    fuse_rating_a: f64,
    output_voltage_v: f64,
) -> String {
    let mut svg = String::with_capacity(4096);
    let h = 100.0 + num_inputs as f64 * 30.0;

    write!(svg, r##"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 {h}" font-family="Arial" font-size="10">"##).unwrap();
    write!(svg, r##"<rect width="400" height="{h}" fill="white"/>"##).unwrap();
    write!(svg, r##"<rect x="120" y="40" width="160" height="{}" fill="none" stroke="black" stroke-width="2" rx="5"/>"##, h - 80.0).unwrap();
    write!(svg, r##"<text x="200" y="30" text-anchor="middle" font-weight="bold">{combiner_id}</text>"##).unwrap();

    for i in 0..num_inputs {
        let y = 60.0 + i as f64 * 30.0;
        // Input line
        write!(svg, r##"<line x1="20" y1="{y}" x2="120" y2="{y}" stroke="black"/>"##).unwrap();
        // Fuse symbol
        write!(svg, r##"<rect x="60" y="{}" width="30" height="10" fill="none" stroke="black" rx="2"/>"##, y - 5.0).unwrap();
        write!(svg, r##"<text x="75" y="{}" text-anchor="middle" font-size="7">{:.0}A</text>"##, y + 3.0, fuse_rating_a).unwrap();
        // Label
        write!(svg, r##"<text x="30" y="{}" font-size="8">S{}</text>"##, y - 8.0, i + 1).unwrap();
    }

    // Output
    let out_y = h / 2.0;
    write!(svg, r##"<line x1="280" y1="{out_y}" x2="380" y2="{out_y}" stroke="black" stroke-width="2"/>"##).unwrap();
    write!(svg, r##"<text x="340" y="{}" font-size="9">{:.0}V DC</text>"##, out_y - 10.0, output_voltage_v).unwrap();

    svg.push_str("</svg>");
    svg
}

/// Generate an AC collection system overview.
pub fn generate_ac_collection_diagram(
    project_name: &str,
    num_inverters: u32,
    transformer_kva: f64,
    collection_voltage_v: f64,
) -> String {
    let mut svg = String::with_capacity(4096);
    let w = 800.0;
    let h = 400.0;

    write!(svg, r##"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" font-family="Arial" font-size="11">"##).unwrap();
    write!(svg, r##"<rect width="{w}" height="{h}" fill="white"/>"##).unwrap();
    write!(svg, r##"<text x="400" y="25" text-anchor="middle" font-size="14" font-weight="bold">{project_name} — AC Collection</text>"##).unwrap();

    let bus_x = 400.0;
    write!(svg, r##"<line x1="{bus_x}" y1="60" x2="{bus_x}" y2="340" stroke="black" stroke-width="3"/>"##).unwrap();
    write!(svg, r##"<text x="{}" y="55" text-anchor="middle" font-size="10">{:.0}V Bus</text>"##, bus_x, collection_voltage_v).unwrap();

    let spacing = 280.0 / num_inverters.max(1) as f64;
    for i in 0..num_inverters {
        let y = 80.0 + i as f64 * spacing;
        // Inverter box
        write!(svg, r##"<rect x="200" y="{}" width="80" height="25" fill="#e3f2fd" stroke="#1976d2" rx="3"/>"##, y - 12.0).unwrap();
        write!(svg, r##"<text x="240" y="{}" text-anchor="middle" font-size="9">INV-{}</text>"##, y + 4.0, i + 1).unwrap();
        // Connection to bus
        write!(svg, r##"<line x1="280" y1="{y}" x2="{bus_x}" y2="{y}" stroke="#1976d2"/>"##).unwrap();
    }

    // Transformer
    write!(svg, r##"<line x1="{bus_x}" y1="200" x2="550" y2="200" stroke="black" stroke-width="2"/>"##).unwrap();
    svg_box_styled(&mut svg, 550.0, 185.0, 80.0, 30.0, &format!("{:.0}kVA", transformer_kva), "#fff3e0", "#e65100");

    // To POI
    write!(svg, r##"<line x1="630" y1="200" x2="750" y2="200" stroke="black" stroke-width="2"/>"##).unwrap();
    write!(svg, r##"<text x="750" y="195" font-size="10" font-weight="bold">→ POI</text>"##).unwrap();

    svg.push_str("</svg>");
    svg
}

/// Generate a SCADA / monitoring architecture diagram.
pub fn generate_scada_diagram(project_name: &str, num_inverters: u32, has_weather_station: bool) -> String {
    let mut svg = String::with_capacity(4096);
    let w = 700.0;
    let h = 500.0;

    write!(svg, r##"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" font-family="Arial" font-size="11">"##).unwrap();
    write!(svg, r##"<rect width="{w}" height="{h}" fill="white"/>"##).unwrap();
    write!(svg, r##"<text x="350" y="25" text-anchor="middle" font-size="14" font-weight="bold">{project_name} — SCADA Architecture</text>"##).unwrap();

    // Cloud / server
    svg_box_styled(&mut svg, 250.0, 50.0, 200.0, 40.0, "Cloud SCADA Server", "#e8eaf6", "#3f51b5");

    // Data logger
    svg_box_styled(&mut svg, 270.0, 140.0, 160.0, 35.0, "Site Data Logger", "#e0f2f1", "#00695c");
    write!(svg, r##"<line x1="350" y1="90" x2="350" y2="140" stroke="#666" stroke-dasharray="4"/>"##).unwrap();

    // Inverters
    let inv_y = 230.0;
    let inv_spacing = 600.0 / (num_inverters.max(1) + 1) as f64;
    for i in 0..num_inverters {
        let x = 50.0 + (i + 1) as f64 * inv_spacing;
        svg_box_styled(&mut svg, x - 35.0, inv_y, 70.0, 30.0, &format!("INV-{}", i + 1), "#e3f2fd", "#1976d2");
        write!(svg, r##"<line x1="{x}" y1="{inv_y}" x2="350" y2="175" stroke="#999" stroke-dasharray="3"/>"##).unwrap();
    }

    // Meter
    svg_box_styled(&mut svg, 100.0, 330.0, 120.0, 30.0, "Revenue Meter", "#fff9c4", "#f57f17");
    write!(svg, r##"<line x1="160" y1="330" x2="350" y2="175" stroke="#999" stroke-dasharray="3"/>"##).unwrap();

    // Weather station
    if has_weather_station {
        svg_box_styled(&mut svg, 450.0, 330.0, 140.0, 30.0, "Weather Station", "#e8f5e9", "#2e7d32");
        write!(svg, r##"<line x1="520" y1="330" x2="350" y2="175" stroke="#999" stroke-dasharray="3"/>"##).unwrap();
    }

    // Protocol labels
    write!(svg, r##"<text x="380" y="120" font-size="8" fill="#666">HTTPS/MQTT</text>"##).unwrap();
    write!(svg, r##"<text x="280" y="210" font-size="8" fill="#666">Modbus TCP / RS-485</text>"##).unwrap();

    svg.push_str("</svg>");
    svg
}

// ========================================================================
// SVG Helper Functions
// ========================================================================

fn svg_line(svg: &mut String, x1: f64, y1: f64, x2: f64, y2: f64) {
    write!(svg, r##"<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="black" stroke-width="1.5"/>"##).unwrap();
}

fn svg_line_colored(svg: &mut String, x1: f64, y1: f64, x2: f64, y2: f64, color: &str) {
    write!(svg, r##"<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="2"/>"##).unwrap();
}

fn svg_box(svg: &mut String, x: f64, y: f64, w: f64, h: f64, label: &str) {
    write!(svg, r##"<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="#f5f5f5" stroke="black" rx="3"/>"##).unwrap();
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="9">{label}</text>"##, x + w / 2.0, y + h / 2.0 + 3.0).unwrap();
}

fn svg_box_styled(svg: &mut String, x: f64, y: f64, w: f64, h: f64, label: &str, fill: &str, stroke: &str) {
    write!(svg, r##"<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}" stroke="{stroke}" rx="4"/>"##).unwrap();
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="9">{label}</text>"##, x + w / 2.0, y + h / 2.0 + 3.0).unwrap();
}

fn svg_pv_array(svg: &mut String, x: f64, y: f64, modules: u32, strings: u32) {
    let w = 80.0;
    let h = 100.0;
    write!(svg, r##"<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="#fff9c4" stroke="#f57f17" rx="3"/>"##).unwrap();
    // PV cell pattern
    for r in 0..3 {
        for c in 0..4 {
            let cx = x + 10.0 + c as f64 * 18.0;
            let cy = y + 10.0 + r as f64 * 28.0;
            write!(svg, r##"<rect x="{cx}" y="{cy}" width="14" height="22" fill="#1565c0" rx="1"/>"##).unwrap();
        }
    }
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="8" fill="#333">{}S × {}P</text>"##,
        x + w / 2.0, y + h + 12.0, modules, strings
    ).unwrap();
}

fn svg_inverter(svg: &mut String, x: f64, y: f64, model: &str, ac_kw: f64) {
    let w = 80.0;
    let h = 50.0;
    write!(svg, r##"<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="#e3f2fd" stroke="#1976d2" rx="4"/>"##).unwrap();
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="8">≈</text>"##, x + w / 2.0, y + 18.0).unwrap();
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="7">{}</text>"##, x + w / 2.0, y + 32.0, model).unwrap();
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="7">{:.0} kW</text>"##, x + w / 2.0, y + 44.0, ac_kw).unwrap();
}

fn svg_transformer(svg: &mut String, x: f64, y: f64, kva: f64, sec_v: f64, pri_v: f64) {
    let w = 80.0;
    let h = 50.0;
    write!(svg, r##"<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="#fff3e0" stroke="#e65100" rx="4"/>"##).unwrap();
    // Two circles (winding symbol)
    let cx = x + w / 2.0;
    let cy = y + h / 2.0;
    write!(svg, r##"<circle cx="{}" cy="{cy}" r="12" fill="none" stroke="#e65100"/>"##, cx - 8.0).unwrap();
    write!(svg, r##"<circle cx="{}" cy="{cy}" r="12" fill="none" stroke="#e65100"/>"##, cx + 8.0).unwrap();
    write!(svg, r##"<text x="{cx}" y="{}" text-anchor="middle" font-size="7">{:.0}kVA</text>"##, y + h + 12.0, kva).unwrap();
    write!(svg, r##"<text x="{cx}" y="{}" text-anchor="middle" font-size="7">{:.0}V/{:.0}V</text>"##, y + h + 22.0, sec_v, pri_v).unwrap();
}

fn svg_disconnect(svg: &mut String, x: f64, y: f64, label: &str) {
    write!(svg, r##"<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="black" stroke-width="2"/>"##, x, y, x + 20.0, y - 15.0).unwrap();
    write!(svg, r##"<circle cx="{x}" cy="{y}" r="3" fill="black"/>"##).unwrap();
    write!(svg, r##"<text x="{}" y="{}" text-anchor="middle" font-size="7">{}</text>"##, x + 10.0, y + 20.0, label.replace('\n', " ")).unwrap();
}

fn svg_meter(svg: &mut String, x: f64, y: f64) {
    write!(svg, r##"<circle cx="{x}" cy="{y}" r="15" fill="none" stroke="black" stroke-width="1.5"/>"##).unwrap();
    write!(svg, r##"<text x="{x}" y="{}" text-anchor="middle" font-size="9">kWh</text>"##, y + 4.0).unwrap();
}

fn svg_poi(svg: &mut String, x: f64, y: f64, kv: f64) {
    write!(svg, r##"<line x1="{x}" y1="{}" x2="{x}" y2="{}" stroke="black" stroke-width="3"/>"##, y - 30.0, y + 30.0).unwrap();
    write!(svg, r##"<text x="{}" y="{}" font-size="10" font-weight="bold">POI</text>"##, x + 10.0, y - 15.0).unwrap();
    write!(svg, r##"<text x="{}" y="{}" font-size="9">{:.1} kV</text>"##, x + 10.0, y + 5.0, kv).unwrap();
}

fn svg_breaker(svg: &mut String, x: f64, y: f64, color: &str) {
    write!(svg, r##"<line x1="{x}" y1="{y}" x2="{}" y2="{}" stroke="{color}" stroke-width="2"/>"##, x + 20.0, y - 10.0).unwrap();
    write!(svg, r##"<circle cx="{x}" cy="{y}" r="3" fill="{color}"/>"##).unwrap();
    write!(svg, r##"<circle cx="{}" cy="{}" r="3" fill="{color}"/>"##, x + 20.0, y - 10.0).unwrap();
}

fn svg_winding(svg: &mut String, x: f64, y: f64, color: &str) {
    write!(svg, r##"<circle cx="{}" cy="{y}" r="10" fill="none" stroke="{color}" stroke-width="1.5"/>"##, x + 10.0).unwrap();
    write!(svg, r##"<circle cx="{}" cy="{y}" r="10" fill="none" stroke="{color}" stroke-width="1.5"/>"##, x + 25.0).unwrap();
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_input() -> SLDInput {
        SLDInput {
            project_name: "Solar Farm Alpha".into(),
            strings_per_inverter: 12,
            modules_per_string: 28,
            num_inverters: 4,
            inverter_model: "SG250HX".into(),
            inverter_ac_kw: 250.0,
            module_model: "TSM-NEG19RC.20".into(),
            module_wp: 605.0,
            transformer_kva: 2500.0,
            transformer_primary_v: 34500.0,
            transformer_secondary_v: 800.0,
            poi_voltage_kv: 34.5,
            has_meter: true,
            has_disconnect: true,
        }
    }

    #[test]
    fn sld_generates_valid_svg() {
        let svg = generate_sld(&test_input());
        assert!(svg.starts_with("<svg"));
        assert!(svg.ends_with("</svg>"));
        assert!(svg.contains("Solar Farm Alpha"));
        assert!(svg.contains("SG250HX"));
        assert!(svg.contains("POI"));
    }

    #[test]
    fn three_ld_generates_valid_svg() {
        let svg = generate_3ld(&test_input());
        assert!(svg.starts_with("<svg"));
        assert!(svg.contains("Three-Line"));
        assert!(svg.contains("A (L1)"));
        assert!(svg.contains("B (L2)"));
        assert!(svg.contains("C (L3)"));
    }

    #[test]
    fn stringing_diagram_generates() {
        let mappings = vec![
            StringMapping { mppt_id: 1, string_id: 1, module_ids: vec!["M1".into(), "M2".into(), "M3".into()] },
            StringMapping { mppt_id: 1, string_id: 2, module_ids: vec!["M4".into(), "M5".into(), "M6".into()] },
        ];
        let svg = generate_stringing_diagram("Test", "INV-1", &mappings);
        assert!(svg.contains("Stringing Diagram"));
        assert!(svg.contains("M1 → M2 → M3"));
    }

    #[test]
    fn combiner_schematic() {
        let svg = generate_combiner_schematic("CB-01", 16, 25.0, 1500.0);
        assert!(svg.contains("CB-01"));
        assert!(svg.contains("25A"));
    }

    #[test]
    fn ac_collection() {
        let svg = generate_ac_collection_diagram("Test", 4, 2500.0, 800.0);
        assert!(svg.contains("AC Collection"));
        assert!(svg.contains("INV-1"));
    }

    #[test]
    fn scada_diagram() {
        let svg = generate_scada_diagram("Test", 4, true);
        assert!(svg.contains("SCADA"));
        assert!(svg.contains("Weather Station"));
    }
}
