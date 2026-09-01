load("@rules_java//java:java_binary.bzl", "java_binary")
load("@rules_jvm_external//:defs.bzl", "java_export")
load("@rules_scala_annex//rules:scala.bzl", "scala_library")
load("//:versions.bzl", "twirl_version")

def generate_twirl_compiler_targets(scala_version):
    # For example 2.13 -> 2_13 or 2-13
    scala_version_underscore = scala_version.replace(".", "_")
    scala_version_dash = scala_version.replace(".", "-")
    if scala_version.startswith("3"):
        scala_library_target = "@twirl_compiler_cli_{}//:org_scala_lang_scala3_library_3".format(scala_version_underscore)
        version_specific_srcs = ["package3.scala"]
    else:
        scala_library_target = "@twirl_compiler_cli_{}//:org_scala_lang_scala_library".format(scala_version_underscore)
        version_specific_srcs = ["package2.scala"]

    main_class = "rulestwirl.twirl.CommandLineTwirlTemplateCompiler"

    scala_library(
        name = "twirl-compiler-lib-{}".format(scala_version_dash),
        srcs = native.glob(
            ["*.scala"],
            exclude = ["package*.scala"],
        ) + version_specific_srcs,
        scalacopts = ["-Xfatal-warnings"],
        visibility = ["//visibility:public"],
        deps_used_whitelist = [
            scala_library_target,
            "@twirl_compiler_cli_{}//:com_google_protobuf_protobuf_java".format(scala_version_underscore),
        ],
        deps = [
            scala_library_target,
            "@twirl_compiler_cli_{}//:com_github_scopt_scopt_{}".format(scala_version_underscore, scala_version_underscore),
            "@twirl_compiler_cli_{}//:org_playframework_twirl_twirl_compiler_{}".format(scala_version_underscore, scala_version_underscore),
            "@twirl_compiler_cli_{}//:org_playframework_twirl_twirl_parser_{}".format(scala_version_underscore, scala_version_underscore),
            "@twirl_compiler_cli_{}//:com_google_protobuf_protobuf_java".format(scala_version_underscore),
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/error",
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/interrupt",
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/sandbox",
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/worker",
        ],
        scala_version = scala_version,
    )

    java_binary(
        name = "twirl-compiler-cli-{}".format(scala_version_dash),
        main_class = main_class,
        visibility = ["//visibility:public"],
        runtime_deps = [":twirl-compiler-lib-{}".format(scala_version_dash)],
    )

    java_export(
        name = "exported-twirl-compiler-{}".format(scala_version_dash),
        maven_coordinates = "com.lucidchart:twirl-compiler-cli_{}:{}".format(scala_version_underscore, twirl_version),
        manifest_entries = {
            "Main-Class": main_class,
        },
        excluded_workspaces = {
            "twirl_compiler_cli_{}".format(scala_version_underscore): None,
            "com_google_protobuf": None,
            "protobuf": None,
        },
        pom_template = "pom.xml.tmpl",
        deps = [
            ":twirl-compiler-lib-{}".format(scala_version_dash),
        ],
        srcs = ["Foo.java"],
    )

def generate_play_2_7_twirl_compiler_targets():
    repository = "@twirl_compiler_cli_2_13_play_2_7"
    scala_library_target = "{}//:org_scala_lang_scala_library".format(repository)

    scala_library(
        name = "twirl-compiler-lib-2-13-play-2-7",
        # Twirl 1.5's compileVirtual has no scalaVersion parameter, so this flavor compiles its
        # own copy of the CLI.
        srcs = ["play-2-7/CommandLineTwirlTemplateCompiler.scala"],
        scalacopts = ["-Xfatal-warnings"],
        visibility = ["//visibility:public"],
        deps_used_whitelist = [
            scala_library_target,
            "{}//:com_google_protobuf_protobuf_java".format(repository),
        ],
        deps = [
            scala_library_target,
            "{}//:com_github_scopt_scopt_2_13".format(repository),
            "{}//:com_typesafe_play_twirl_compiler_2_13".format(repository),
            "{}//:com_typesafe_play_twirl_parser_2_13".format(repository),
            "{}//:com_google_protobuf_protobuf_java".format(repository),
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/error",
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/interrupt",
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/sandbox",
            "@rules_scala_annex//src/main/scala/higherkindness/rules_scala/common/worker",
        ],
        scala_version = "2.13",
    )

    java_binary(
        name = "twirl-compiler-cli-2-13-play-2-7",
        main_class = "rulestwirl.twirl.CommandLineTwirlTemplateCompiler",
        visibility = ["//visibility:public"],
        runtime_deps = [
            ":twirl-compiler-lib-2-13-play-2-7",
            # The Play 2.7 era Twirl compiler needs scala-parser-combinators at runtime
            "{}//:org_scala_lang_modules_scala_parser_combinators_2_13".format(repository),
        ],
    )
