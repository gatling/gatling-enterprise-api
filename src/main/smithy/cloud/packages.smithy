$version: "2"

namespace io.gatling.enterprise.api.packages

use alloy#UUID
use alloy#simpleRestJson
use io.gatling.enterprise.api#Action
use io.gatling.enterprise.api#GenericClientError
use io.gatling.enterprise.api#GenericServerError
use io.gatling.enterprise.api#NotFoundError
use io.gatling.enterprise.api#apiToken

@simpleRestJson
@apiToken
service PackageService {
  version: "0.0.0"
  operations: [CreatePackage, ReadPackage, ListPackage, UpdatePackageFile]
  errors: [GenericServerError, GenericClientError]
}

@http(method: "POST", uri: "/api/public/packages", code: 200)
@auth([apiToken])
operation CreatePackage {
  input: CreatePackageRequest
  output: PackageResponse
}

@readonly
@http(method: "GET", uri: "/api/public/packages/{id}", code: 200)
@auth([apiToken])
operation ReadPackage {
  input: ReadPackageRequest
  output: PackageResponse
  errors: [NotFoundError]
}

@readonly
@http(method: "GET", uri: "/api/public/packages", code: 200)
operation ListPackage {
  output: ListPackageResponse
}

@http(method: "PUT", uri: "/api/public/packages/{id}/file", code: 200)
operation UpdatePackageFile {
  input: UpdatePackageFileRequest
  output: UpdatePackageFileResponse
}

enum PackageStorageType {
  @enumValue("private")
  PRIVATE
  @enumValue("public")
  PUBLIC
}

@mixin
structure PackageCommon {
  @required storageType: PackageStorageType
  @required teamId: UUID
  @required name: String
}

enum PackageAction {
  @enumValue("upload-private")
  UPLOAD_PRIVATE
}

map PackageActions {
  key: PackageAction
  value: String
}

structure PackageData with [PackageCommon] {
  @required id: String
  file: PackageFileResponse
  @required _actions: PackageActions
}

structure PackageResponse {
  @required data: PackageData
}

@mixin
structure PackageFile {
  @required filename: String
  @timestampFormat("http-date") @required lastUpdate: Timestamp
  @required gatling: String
  @required checksum: String
  @required simulationClasses: SimulationClasses
}

structure PackageFileResponse with [PackageFile] {}

list SimulationClasses {
  member: String
}

structure CreatePackageRequest with [PackageCommon] {}

structure ReadPackageRequest {
  @httpLabel
  @required id: String
}

structure UpdatePackageFileRequest with [PackageFile] {
  @httpLabel
  @required id: String
}

structure ListPackageMember with [PackageCommon] {
  @required id: String
}

list ListPackageData {
  member: ListPackageMember
}

structure ListPackageResponse {
  @required data: ListPackageData
}

structure UpdatePackageFileResponse {
  @required data: PackageFileResponse
}
