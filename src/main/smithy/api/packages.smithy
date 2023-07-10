$version: "2"

namespace io.gatling.enterprise.api

use alloy#UUID
use alloy#simpleRestJson
use io.gatling.enterprise.api#ActionResponse
use io.gatling.enterprise.api#GenericClientError
use io.gatling.enterprise.api#GenericServerError
use io.gatling.enterprise.api#NotFoundError
use io.gatling.enterprise.api#UnauthorizedError
use io.gatling.enterprise.api#controlPlaneToken

@simpleRestJson
@controlPlaneToken
service PrivatePackageService {
  version: "0.0.0"
  operations: [ReadPrivatePackage, UpdatePrivatePackageFile]
  errors: [GenericServerError, GenericClientError, UnauthorizedError, NotFoundError]
}


@readonly
@http(method: "GET", uri: "/api/control-plane/private-PrivatePackages/{id}", code: 200)
@auth([controlPlaneToken])
operation ReadPrivatePackage {
  input := {
    @httpLabel
    @required id: UUID

    @httpQuery("apiToken")
    @required apiToken: String
  }
  output: ReadPrivatePackageResponse
}

structure ReadPrivatePackageResponse {
  @required data: PrivatePackageResponse
}

@http(method: "PUT", uri: "/api/control-plane/private-PrivatePackages/{id}/file", code: 200)
@auth([controlPlaneToken])
operation UpdatePrivatePackageFile {
  input := with [PrivatePackageFileMixin] {
    @httpLabel
    @required id: UUID
  }
  output: UpdatePrivatePackageFileResponse
}

structure UpdatePrivatePackageFileResponse {
  @required data: PrivatePackageFileResponse
}

@mixin
structure PrivatePackageCommon {
  @required teamId: UUID
  @required name: String
}

structure SimplePrivatePackageResponse with [PrivatePackageCommon] {
  @required id: UUID
}

enum PrivatePackageActionResponse {
  UPLOAD_PRIVATE = "upload-private"
}

map PrivatePackageActionsResponse {
  key: PrivatePackageActionResponse
  value: ActionResponse
}

structure PrivatePackageResponse with [PrivatePackageCommon] {
  @required id: UUID
  file: PrivatePackageFileResponse
  @required _actions: PrivatePackageActionsResponse
}

list SimulationClasses {
  member: String
}

@mixin
structure PrivatePackageFileMixin {
  @required filename: String
  @timestampFormat("http-date") @required lastUpdate: Timestamp
  @required gatling: String
  @required checksum: String
  @required simulationClasses: SimulationClasses
}

structure PrivatePackageFileResponse with [PrivatePackageFileMixin] {}

structure SimplePrivatePackageResponse with [PrivatePackageCommon] {
  @required id: UUID
}
