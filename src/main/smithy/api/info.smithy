$version: "2"

namespace io.gatling.enterprise.api.info

use io.gatling.enterprise.api#GenericServerError
use io.gatling.enterprise.api#GenericClientError
use alloy#simpleRestJson

@simpleRestJson
service InfoEndpoint {
    version: "0.0.1"
    operations: [info]
    errors: [GenericServerError, GenericClientError]
}

@readonly
@http(method: "GET", uri: "/api/info", code: 200)
@documentation("endpoint that provide some default information of the application.")
operation info {
    output : BodyResponse
}

structure BodyResponse {
    @documentation("The current version of application")
    @required frontLineVersion: String
    @documentation("The minimum version of Gatling engine supported.")
    @required minSupportedGatlingVersion: String
    @documentation("The maximum version of Gatling engine supported.")
    @required maxSupportedGatlingVersion: String
    @documentation("The version of plugins supported.")
    @required pluginVersions: PluginVersions
    @documentation("The url endpoint of authentication system.")
    @required authUrl: String
    @documentation("The api key of Amplitude.")
    @required amplitudeApiKey: String
    @documentation("The different default values.")
    @required default: DefaultValues
}

structure PluginVersions {
    @documentation("The ci plugin version.")
    @required ci: String
    @documentation("The grafana plugin version.")
    @required grafana: String
}

structure DefaultValues {
    @documentation("The id of default value for location.")
    @required location: String
}
