package(
    default_visibility = ["//visibility:public"],
    licenses = ["restricted"],  # CC-NC
)

load("//3rdparty/openscad:openscad.bzl", "openscad_library")

openscad_library(
    name = "thingiverse",
    srcs = glob([
        "thingiverse.scad",
        "**/*.stl"
    ]),
)