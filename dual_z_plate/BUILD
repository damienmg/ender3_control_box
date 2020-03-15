load("//3rdparty/openscad:openscad.bzl", "openscad_library", "openscad_artifact")

openscad_library(
    name = "components",
    srcs = ["components.scad"],
    deps = [
        "//3rdparty/Ender3",
        "//3rdparty/thingiverse",
    ],
)


openscad_library(
    name = "dual_z_plate",
    srcs = ["dual_z_plate.scad"],
    deps = [
        ":components",
    ],
)

openscad_artifact(
    name = "SecondZPlate",
    module = "SecondZPlate",
    deps = [":dual_z_plate"],
)
