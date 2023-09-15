scalaVersion := "2.13.12"
name := "gatling-enterprise-api"
organization := "io.gatling.enterprise"

autoScalaLibrary := false
crossPaths := false

enablePlugins(GatlingVersioningPlugin)
enablePlugins(GatlingBasicInfoPlugin)
enablePlugins(GatlingReleasePlugin)
enablePlugins(SmithyBuildPlugin)

libraryDependencies ++= Seq(
  "com.disneystreaming.alloy" % "alloy-core" % "0.2.3"
)

Compile / compile := ((Compile / compile) dependsOn (Compile / smithyBuild)).value
Compile / packageBin / mappings := {
  val defaultMappings = (Compile / packageBin / mappings).value
  val smithyDirectory = (Compile / smithyOutputDir).value / "source" / "sources"
  val smithyFiles = smithyDirectory ** "**" pair Path.rebase(smithyDirectory,  "META-INF/smithy")
  smithyFiles ++ defaultMappings
}
Compile / unmanagedSourceDirectories += sourceDirectory.value / "main" / "smithy"
