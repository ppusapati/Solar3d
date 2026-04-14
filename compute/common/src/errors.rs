use std::fmt;

/// Unified error type for all compute kernels.
#[derive(Debug, Clone, PartialEq)]
pub enum ComputeError {
    /// Caller passed invalid input parameters.
    InvalidInput(String),
    /// Numerical issue encountered during computation (overflow, NaN, singularity).
    NumericalError(String),
    /// Graph is disconnected or topology is infeasible.
    TopologyError(String),
    /// Optimization failed to converge within the configured budget.
    ConvergenceFailure(String),
    /// Internal invariant violated — indicates a bug.
    InternalError(String),
}

impl fmt::Display for ComputeError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ComputeError::InvalidInput(msg) => write!(f, "invalid input: {}", msg),
            ComputeError::NumericalError(msg) => write!(f, "numerical error: {}", msg),
            ComputeError::TopologyError(msg) => write!(f, "topology error: {}", msg),
            ComputeError::ConvergenceFailure(msg) => write!(f, "convergence failure: {}", msg),
            ComputeError::InternalError(msg) => write!(f, "internal error: {}", msg),
        }
    }
}

impl std::error::Error for ComputeError {}

/// Convenience conversion from `String` error messages to `ComputeError::InvalidInput`.
impl From<String> for ComputeError {
    fn from(s: String) -> Self {
        ComputeError::InvalidInput(s)
    }
}

impl From<&str> for ComputeError {
    fn from(s: &str) -> Self {
        ComputeError::InvalidInput(s.to_string())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn display_formats_correctly() {
        let e = ComputeError::InvalidInput("radius must be positive".to_string());
        assert_eq!(e.to_string(), "invalid input: radius must be positive");

        let e = ComputeError::TopologyError("graph is disconnected".to_string());
        assert_eq!(e.to_string(), "topology error: graph is disconnected");
    }

    #[test]
    fn from_string_yields_invalid_input() {
        let e: ComputeError = "bad param".into();
        assert_eq!(e, ComputeError::InvalidInput("bad param".to_string()));
    }
}
