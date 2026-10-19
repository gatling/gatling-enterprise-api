scalaVersion := "2.13.18"
name := "gatling-enterprise-api"
organization := "io.gatling.enterprise"

autoScalaLibrary := false
crossPaths := false

enablePlugins(GatlingVersioningPlugin)
enablePlugins(GatlingBasicInfoPlugin)
enablePlugins(GatlingPublishPlugin)
// Exception: neither GatlingCorpPlugin nor GatlingOssPlugin, so artifacts must not be signed as no GPG key is available.
// Switch to GatlingCorpPlugin if this artifact is private, or to GatlingOssPlugin (with GPG keys in CI) if it is public.
GatlingPublishPlugin.unsignedAetherArtifact
enablePlugins(SmithyBuildPlugin)

libraryDependencies ++= Seq(
  "com.disneystreaming.alloy" % "alloy-core" % "0.3.40"
)

Compile / compile := ((Compile / compile) dependsOn (Compile / smithyBuild)).value
Compile / packageBin / mappings := {
  val defaultMappings = (Compile / packageBin / mappings).value
  val smithyDirectory = (Compile / smithyOutputDir).value / "source" / "sources"
  val smithyFiles = smithyDirectory ** "**" pair Path.rebase(smithyDirectory, "META-INF/smithy")
  smithyFiles ++ defaultMappings
}
Compile / unmanagedSourceDirectories += sourceDirectory.value / "main" / "smithy"
