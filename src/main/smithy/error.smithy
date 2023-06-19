namespace io.gatling.enterprise.api

@error("server")
structure GenericServerError {
  @required
  error: ErrorContent
}

@error("client")
structure GenericClientError {
  @required
  error: ErrorContent
}

structure ErrorContent {
  @required
  message: String
  @required
  errors: ErrorList
}

list ErrorList {
  member: ErrorDetail
}

structure ErrorDetail {
  @required
  message: String
}

@error("client")
@httpError(404)
structure NotFoundError {}

@error("client")
@httpError(401)
structure UnauthorizedError {}
