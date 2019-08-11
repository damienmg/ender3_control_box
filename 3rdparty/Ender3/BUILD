package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],  # CC-BY
)

load("//3rdparty/openscad:openscad.bzl", "openscad_library")

openscad_library(
    name = "Ender3",
    srcs = glob([
        "*.stl",
        "ender3.scad",
    ]),
)
