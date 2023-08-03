import sbt.Keys._
import sbt._
import sbt.Def.spaceDelimited
import sbt.nio.file.FileTreeView
import sbt.plugins.JvmPlugin
import software.amazon.smithy.cli.SmithyCli

import scala.jdk.CollectionConverters._

object SmithyBuildPlugin extends AutoPlugin {
  override def trigger: PluginTrigger = allRequirements
  override def requires: Plugins = JvmPlugin

  object autoImport {
    val smithyDisableModelDiscovery = settingKey[Boolean]("not --discover")
    val smithyAllowUnknownTraits = settingKey[Boolean]("--allow-unknown-traits")
    val smithyModelDiscoveryClasspath = taskKey[Classpath]("smithyModelDiscoveryClasspath")
    val smithyBuild = taskKey[Unit]("smithy build")
    val smithyOutputDir = settingKey[File]("output dir")
    val smithyConfigFiles = settingKey[Seq[File]]("config files")
    val smithyModels = settingKey[Seq[Glob]]("smithy models")
    val smithy = inputKey[Unit]("smithy")
  }

  import autoImport._

  override lazy val projectSettings: Seq[Setting[_]] = configure(Compile)

  def configure(config: Configuration): Seq[Setting[_]] = inConfig(config)(Seq(
    smithyModels := Seq(sourceDirectory.value.toGlob / "smithy" / ** / "*.smithy"),
    smithyOutputDir := target.value / "smithyprojections" / normalizedName.value,
    smithyConfigFiles := Seq(baseDirectory.value / "smithy-build.json"),
    smithyBuild := {
      val args: Seq[String] = Seq(
        Seq("build"),
        Seq("--output", smithyOutputDir.value.getAbsolutePath),
        smithyConfigFiles.value.filter(_.exists()).flatMap(configFile => Seq("--config", configFile.getAbsolutePath)),
        if(smithyAllowUnknownTraits.value) Seq("--allow-unknown-traits") else Nil,
        if(smithyModelDiscoveryClasspath.value.nonEmpty) Seq("--discover-classpath", smithyModelDiscoveryClasspath.value.map(_.data.getAbsolutePath).mkString(":")) else if (!smithyDisableModelDiscovery.value) Seq("--discover") else Nil,
        Seq("--"),
        FileTreeView.default.list(smithyModels.value).map(_._1.toFile).filter(_.exists).map(_.getAbsolutePath)
      ).flatten
      streams.value.log.info(s"Running command smithy ${args.mkString(" ")}")
      SmithyCli.create().classLoader(this.getClass.getClassLoader).run(args.asJava)
    },
    smithy := {
      val args: Seq[String] = spaceDelimited("<arg>").parsed
      SmithyCli.create().classLoader(this.getClass.getClassLoader).run(args.asJava)
    }
  ))

  override lazy val buildSettings: Seq[Setting[_]] = Seq(
    smithyAllowUnknownTraits := false,
    smithyDisableModelDiscovery := false,
    smithyModelDiscoveryClasspath := Nil,
  )

  override lazy val globalSettings: Seq[Setting[_]] = Seq()
}
