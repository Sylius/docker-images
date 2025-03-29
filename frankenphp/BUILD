load("@io_bazel_rules_docker//container:import.bzl", "container_import")
load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")
load(":php-arch.bzl", "ARCHITECTURES")
load(":php-version.bzl", "FRANKENPHP_VERSION")

package(default_visibility = ["//visibility:public"])

[
    container_test(
        name = "frankenphp" + FRANKENPHP_VERSION + "_" + arch + "_test",
        size = "medium",
        configs = ["testdata/frankenphp" + FRANKENPHP_VERSION + "_" + arch + ".yaml"],
        image = "@image" + arch + "//image",
    )
    for arch in ARCHITECTURES
]
