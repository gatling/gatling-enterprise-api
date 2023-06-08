scalaVersion := "2.13.11"
name := "gatling-enterprise-api"
organization := "io.gatling.enterprise"

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
