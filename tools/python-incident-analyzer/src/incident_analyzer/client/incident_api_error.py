"""API exceptions for the incident analyzer."""


class IncidentApiError(RuntimeError):
    """Raised when the Java incident backend returns an invalid response."""

    def __init__(self, message: str, *, status_code: int | None = None) -> None:
        super().__init__(message)
        self.status_code = status_code