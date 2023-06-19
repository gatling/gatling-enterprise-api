$version: "2"

namespace io.gatling.enterprise.api

structure EndpointActionResponse {
  @required callable: Boolean
}

structure ActionResponse {
  endpoint: EndpointActionResponse
}
