ThisBuild / scalaVersion := "2.12.17"
ThisBuild / name := "gatling-enterprise-api"
ThisBuild / organization := "io.gatling.enterprise"
ThisBuild / version := "0.1.0-SNAPSHOT"

lazy val root = (project in file("."))
  .settings(
    name := "gatling-enterprise-api"
  )

enablePlugins(Smithy4sCodegenPlugin)

libraryDependencies ++= Seq(
  "com.disneystreaming.smithy4s" %% "smithy4s-http4s" % smithy4sVersion.value
)
(Compile / packageBin / mappings) := {
  val defaultMappings = (Compile / packageBin / mappings).value
  defaultMappings.filterNot { case (file, path) =>
    // Filter out OpenAPI JSON file
    path.endsWith(".json")
  }
}
