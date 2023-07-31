$version: "2"

namespace io.gatling.enterprise.api

@authDefinition
@trait(selector: "service")
structure controlPlaneToken {
}


@authDefinition
@trait(selector: "service")
structure browserAccess {
}
