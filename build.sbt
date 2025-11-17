scalaVersion := "2.13.17"
name := "gatling-enterprise-api"
organization := "io.gatling.enterprise"

autoScalaLibrary := false
crossPaths := false

enablePlugins(GatlingVersioningPlugin)
enablePlugins(GatlingBasicInfoPlugin)
enablePlugins(GatlingReleasePlugin)
enablePlugins(SmithyBuildPlugin)

libraryDependencies ++= Seq(
  "com.disneystreaming.alloy" % "alloy-core" % "0.3.34"
)

Compile / compile := ((Compile / compile) dependsOn (Compile / smithyBuild)).value
Compile / packageBin / mappings := {
  val defaultMappings = (Compile / packageBin / mappings).value
  val smithyDirectory = (Compile / smithyOutputDir).value / "source" / "sources"
  val smithyFiles = smithyDirectory ** "**" pair Path.rebase(smithyDirectory, "META-INF/smithy")
  smithyFiles ++ defaultMappings
}
Compile / unmanagedSourceDirectories += sourceDirectory.value / "main" / "smithy"

lazy val openapi = (project in file("openapi"))
  .enablePlugins(PreprocessPlugin)
  .settings(
    Preprocess / sourceDirectory := sourceDirectory.value / "main" / "openapi",
    Preprocess / preprocessRules := Seq(
      ("API_URL_PLACEHOLDER".r, _ => "https://api.gatling.io")
    ),
    Preprocess / preprocessIncludeFilter := "*.yaml",
    Preprocess / target := target.value / "openapi"
  )
