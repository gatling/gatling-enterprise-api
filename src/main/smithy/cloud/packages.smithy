$version: "2"

namespace io.gatling.enterprise.api.packages

use alloy#UUID
use alloy#simpleRestJson
use io.gatling.enterprise.api#ActionResponse
use io.gatling.enterprise.api#GenericClientError
use io.gatling.enterprise.api#GenericServerError
use io.gatling.enterprise.api#NotFoundError
use io.gatling.enterprise.api#controlPlaneToken

@simpleRestJson
@controlPlaneToken
service PackageService {
  version: "0.0.0"
  operations: [CreatePackage, ReadPackage, UpdatePackageFile]
  errors: [GenericServerError, GenericClientError]
}

@http(method: "POST", uri: "/api/control-plane/private-packages", code: 200)
@auth([controlPlaneToken])
operation CreatePackage {
  input := with [PackageCommon] {}
  output: CreatePackageResponse
}

structure CreatePackageResponse {
  @required data: SimplePackageResponse
}

@readonly
@http(method: "GET", uri: "/api/control-plane/private-packages/{id}", code: 200)
@auth([controlPlaneToken])
operation ReadPackage {
  input := {
    @httpLabel
    @required id: UUID

    @httpQuery("apiToken")
    @required apiToken: String
  }
  output: ReadPackageResponse
  errors: [NotFoundError]
}

structure ReadPackageResponse {
  @required data: PackageResponse
}

@http(method: "PUT", uri: "/api/control-plane/private-packages/{id}/file", code: 200)
operation UpdatePackageFile {
  input := with [PackageFileMixin] {
    @httpLabel
    @required id: UUID
  }
  output: UpdatePackageFileResponse
}

structure UpdatePackageFileResponse {
  @required data: PackageFileResponse
}

enum PackageStorageType {
  PRIVATE = "private"
  PUBLIC = "public"
}

@mixin
structure PackageCommon {
  @required storageType: PackageStorageType
  @required teamId: UUID
  @required name: String
}

structure SimplePackageResponse with [PackageCommon] {
  @required id: UUID
}

enum PackageActionResponse {
  UPLOAD_PRIVATE = "upload-private"
}

map PackageActionsResponse {
  key: PackageActionResponse
  value: ActionResponse
}

structure PackageResponse with [PackageCommon] {
  @required id: UUID
  file: PackageFileResponse
  @required _actions: PackageActionsResponse
}

list SimulationClasses {
  member: String
}

@mixin
structure PackageFileMixin {
  @required filename: String
  @timestampFormat("http-date") @required lastUpdate: Timestamp
  @required gatling: String
  @required checksum: String
  @required simulationClasses: SimulationClasses
}

structure PackageFileResponse with [PackageFileMixin] {}

structure SimplePackageResponse with [PackageCommon] {
  @required id: UUID
}
