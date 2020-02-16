load("@//3rdparty/openscad:openscad.bzl", "openscad_library")

openscad_library(
    name = "nopscadlib",
    srcs = glob([
        "**/*.scad",
        "**/*.stl",
    ]),
    visibility = ["//visibility:public"],
)
