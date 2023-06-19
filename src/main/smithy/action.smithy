$version: "2"

namespace io.gatling.enterprise.api

structure EndpointAction {
  callable: Boolean
}

structure Action {
  endpoint: EndpointAction
}
