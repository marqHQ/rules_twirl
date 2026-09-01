load("@rules_scala_annex//rules:scala.bzl", "scala_test")
load("//twirl:twirl.bzl", "twirl_templates")

def generate_twirl_test_targets(scala_version):
    # For example 2.13 -> 2-13 or 2_13
    scala_version_dash = scala_version.replace(".", "-")
    scala_version_underscore = scala_version.replace(".", "_")

    twirl_templates(
        name = "twirl-test-templates-basic-{}".format(scala_version_dash),
        srcs = [
            "twirl-templates/twirl/com/foo/views/hello.scala.html",
            "twirl-templates/twirl/com/foo/views/hello.scala.js",
            "twirl-templates/twirl/com/foo/views/hello.scala.txt",
            "twirl-templates/twirl/com/foo/views/hello.scala.xml",
        ],
        scala_version = scala_version,
        source_directory = "twirl-templates",
        visibility = ["//visibility:public"],
    )

    twirl_templates(
        name = "twirl-test-templates-additional-imports-{}".format(scala_version_dash),
        srcs = [
            "twirl-templates/twirl/com/foo/views/addImports.scala.txt",
        ],
        additional_imports = ["rulestwirl.test.Person"],
        scala_version = scala_version,
        source_directory = "twirl-templates",
        visibility = ["//visibility:public"],
    )

    twirl_templates(
        name = "twirl-test-templates-custom-formatter-{}".format(scala_version_dash),
        srcs = [
            "twirl-templates/twirl/com/foo/views/customFormatter.scala.txt",
        ],
        additional_imports = ["rulestwirl.test.Person"],
        scala_version = scala_version,
        source_directory = "twirl-templates",
        template_formats = {
            "txt": "rulestwirl.test.StrangeTxtFormat",
        },
        visibility = ["//visibility:public"],
    )

    scala_test(
        name = "twirl-compiler-test-{}".format(scala_version_dash),
        srcs = [
            "Person.scala",
            "StrangeTxtFormatter.scala",
            "TwirlCompilerTest.scala",
            ":twirl-test-templates-additional-imports-{}".format(scala_version_dash),
            ":twirl-test-templates-basic-{}".format(scala_version_dash),
            ":twirl-test-templates-custom-formatter-{}".format(scala_version_dash),
        ],
        scala_version = scala_version,
        deps = [
            "@twirl_test_{}//:org_playframework_twirl_twirl_api_{}".format(scala_version_underscore, scala_version_underscore),
            "@twirl_test_{}//:org_specs2_specs2_common_{}".format(scala_version_underscore, scala_version_underscore),
            "@twirl_test_{}//:org_specs2_specs2_core_{}".format(scala_version_underscore, scala_version_underscore),
            "@twirl_test_{}//:org_specs2_specs2_matcher_{}".format(scala_version_underscore, scala_version_underscore),
        ],
    )

def generate_play_2_7_twirl_test_targets():
    repository = "@twirl_test_2_13_play_2_7"

    twirl_templates(
        name = "twirl-test-templates-basic-2-13-play-2-7",
        srcs = [
            "twirl-templates/twirl/com/foo/views/hello.scala.html",
            "twirl-templates/twirl/com/foo/views/hello.scala.js",
            "twirl-templates/twirl/com/foo/views/hello.scala.txt",
            "twirl-templates/twirl/com/foo/views/hello.scala.xml",
        ],
        source_directory = "twirl-templates",
        scala_version = "play-2-7_2.13",
        visibility = ["//visibility:public"],
    )

    twirl_templates(
        name = "twirl-test-templates-additional-imports-2-13-play-2-7",
        srcs = [
            "twirl-templates/twirl/com/foo/views/addImports.scala.txt",
        ],
        additional_imports = ["rulestwirl.test.Person"],
        source_directory = "twirl-templates",
        scala_version = "play-2-7_2.13",
        visibility = ["//visibility:public"],
    )

    twirl_templates(
        name = "twirl-test-templates-custom-formatter-2-13-play-2-7",
        srcs = [
            "twirl-templates/twirl/com/foo/views/customFormatter.scala.txt",
        ],
        additional_imports = ["rulestwirl.test.Person"],
        source_directory = "twirl-templates",
        template_formats = {
            "txt": "rulestwirl.test.StrangeTxtFormat",
        },
        scala_version = "play-2-7_2.13",
        visibility = ["//visibility:public"],
    )

    scala_test(
        name = "twirl-compiler-test-2-13-play-2-7",
        srcs = [
            "Person.scala",
            "StrangeTxtFormatter.scala",
            "TwirlCompilerTest.scala",
            ":twirl-test-templates-additional-imports-2-13-play-2-7",
            ":twirl-test-templates-basic-2-13-play-2-7",
            ":twirl-test-templates-custom-formatter-2-13-play-2-7",
        ],
        scala_version = "2.13",
        deps = [
            "{}//:com_typesafe_play_twirl_api_2_13".format(repository),
            "{}//:org_specs2_specs2_common_2_13".format(repository),
            "{}//:org_specs2_specs2_core_2_13".format(repository),
            "{}//:org_specs2_specs2_matcher_2_13".format(repository),
        ],
    )
