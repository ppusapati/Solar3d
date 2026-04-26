use serde::de::DeserializeOwned;
use serde::Serialize;

pub use tiny_http::{Method, Request, Response, Server, StatusCode};

/// Bind an HTTP server, exiting the process with a clear log message and
/// non-zero status if bind fails. Bridges call this from `main` instead of
/// `.expect()` so that a port collision in production is reported as an
/// operational failure rather than a Rust panic with backtrace noise.
///
/// `bridge_name` is used in log output; `addr` is the bind address (e.g.
/// "127.0.0.1:8083").
pub fn bind_or_exit(bridge_name: &str, addr: &str) -> Server {
    match Server::http(addr) {
        Ok(server) => {
            eprintln!("[{}] listening on http://{}", bridge_name, addr);
            server
        }
        Err(err) => {
            eprintln!(
                "[{}] FATAL: failed to bind on {}: {}. Check that the port is free and the process has permission to listen.",
                bridge_name, addr, err
            );
            std::process::exit(1);
        }
    }
}

#[derive(Debug, Serialize)]
struct ErrorResponse {
    error: String,
}

pub fn read_json<T: DeserializeOwned>(request: &mut Request) -> Result<T, String> {
    let mut body = String::new();
    request
        .as_reader()
        .read_to_string(&mut body)
        .map_err(|e| format!("invalid request body: {}", e))?;

    serde_json::from_str(&body).map_err(|e| format!("invalid json payload: {}", e))
}

pub fn respond_json<T: Serialize>(request: Request, status: StatusCode, body: &T) {
    let json = match serde_json::to_string(body) {
        Ok(v) => v,
        Err(err) => {
            let fallback = ErrorResponse {
                error: format!("failed to serialize response: {}", err),
            };
            respond_json(request, StatusCode(500), &fallback);
            return;
        }
    };

    // Header literal is a constant, so from_bytes cannot fail. unwrap()
    // here is the canonical pattern for "infallible by construction".
    let header = tiny_http::Header::from_bytes(b"Content-Type", b"application/json")
        .expect("constant content-type header");
    let response = Response::from_string(json)
        .with_status_code(status)
        .with_header(header);

    // Client may have disconnected before we wrote the response — there is
    // nothing useful to do at this layer; downstream connection metrics will
    // surface chronic write failures.
    let _ = request.respond(response);
}

pub fn respond_error(request: Request, status: StatusCode, message: String) {
    let payload = ErrorResponse { error: message };
    respond_json(request, status, &payload);
}

pub fn respond_not_found(request: Request) {
    respond_error(request, StatusCode(404), "route not found".to_string());
}
