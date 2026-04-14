use serde::de::DeserializeOwned;
use serde::Serialize;

pub use tiny_http::{Method, Request, Response, Server, StatusCode};

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

    let response = Response::from_string(json)
        .with_status_code(status)
        .with_header(
            tiny_http::Header::from_bytes(b"Content-Type", b"application/json")
                .expect("valid content-type header"),
        );

    let _ = request.respond(response);
}

pub fn respond_error(request: Request, status: StatusCode, message: String) {
    let payload = ErrorResponse { error: message };
    respond_json(request, status, &payload);
}

pub fn respond_not_found(request: Request) {
    respond_error(request, StatusCode(404), "route not found".to_string());
}
