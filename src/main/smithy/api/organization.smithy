$version: "2"

namespace io.gatling.enterprise.api.internal.organizations


use alloy#simpleRestJson
use io.gatling.enterprise.api#browserAccess
use io.gatling.enterprise.api#GenericServerError
use io.gatling.enterprise.api#GenericClientError
use io.gatling.enterprise.api#UnauthorizedError
use io.gatling.enterprise.api#BadRequestError



@simpleRestJson
@browserAccess
service OrganizationEndpoint {
    version: "0.0.0"
    operations: [findAll]
    errors: [GenericServerError, GenericClientError, UnauthorizedError, BadRequestError]
}

@readonly
@http(method: "GET", uri: "/api/private/organizations", code: 200)
@auth([browserAccess])
operation findAll {
    output : OrganizationOutput
}
structure OrganizationOutput {
    @required @httpPayload responseBody: Organizations
}

list Organizations {
    member: Organization
}

structure Organization {
    @required id: String
    @required name: String
    @required slug: String
}
