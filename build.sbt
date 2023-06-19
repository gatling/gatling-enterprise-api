scalaVersion := "2.13.11"
name := "gatling-enterprise-api"
organization := "io.gatling.enterprise"

enablePlugins(GatlingCorpPlugin)
enablePlugins(Smithy4sCodegenPlugin)

libraryDependencies ++= Seq(
  "com.disneystreaming.smithy4s" %% "smithy4s-http4s" % smithy4sVersion.value,
  "com.disneystreaming.alloy" % "alloy-core" % "0.2.2"
)

(Compile / packageBin / mappings) := {
  val defaultMappings = (Compile / packageBin / mappings).value
  defaultMappings.filterNot { case (file, path) =>
    // Filter out OpenAPI JSON file
    path.endsWith(".json")
  }
}
