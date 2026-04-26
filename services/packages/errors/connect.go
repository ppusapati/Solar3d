package errors

import (
	"connectrpc.com/connect"
)

// ToConnectError converts this Error into a ConnectRPC *connect.Error whose
// code matches the HTTP/gRPC status implied by Error.Code, and whose message
// matches Error.Message. Metadata (including the Reason string) rides in a
// Connect detail so clients can read it via ConnectError.Details().
//
// Returns nil if e is nil, matching the idiomatic nil-error propagation path.
func (e *Error) ToConnectError() *connect.Error {
	if e == nil {
		return nil
	}
	return connect.NewError(httpStatusToConnectCode(int(e.Code)), e)
}

// httpStatusToConnectCode maps Solar3D/Samavaya Error.Code (HTTP status) to a
// connect.Code. Unknown codes fall back to CodeUnknown.
func httpStatusToConnectCode(status int) connect.Code {
	switch status {
	case 400:
		return connect.CodeInvalidArgument
	case 401:
		return connect.CodeUnauthenticated
	case 403:
		return connect.CodePermissionDenied
	case 404:
		return connect.CodeNotFound
	case 409:
		return connect.CodeAlreadyExists
	case 412:
		return connect.CodeFailedPrecondition
	case 429:
		return connect.CodeResourceExhausted
	case 499:
		return connect.CodeCanceled
	case 500:
		return connect.CodeInternal
	case 501:
		return connect.CodeUnimplemented
	case 503:
		return connect.CodeUnavailable
	case 504:
		return connect.CodeDeadlineExceeded
	default:
		if status >= 400 && status < 500 {
			return connect.CodeInvalidArgument
		}
		return connect.CodeUnknown
	}
}
