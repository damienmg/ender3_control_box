load("//3rdparty/openscad:openscad.bzl", "openscad_library", "openscad_artifact")

openscad_library(
    name = "params",
    srcs = ["params.scad"],
)

openscad_library(
    name = "components",
    srcs = ["components.scad"],
    deps = [
        ":params",
        "@NopSCADlib//:nopscadlib",
        "//3rdparty/bltouch",
        "//3rdparty/BMG",
        "//3rdparty/Ender3",
        "//3rdparty/E3DV6",
        "//3rdparty/thingiverse",
    ],
)


openscad_library(
    name = "tank-hotend",
    srcs = ["enclosure.scad"],
    deps = [
        ":components",
        ":params",
        "@NopSCADlib//:nopscadlib",
    ],
)


[
    openscad_artifact(
        name = name,
        module = name,
        deps = [":tank-hotend"],
    )
    for name in [
        "WireGuide",
        "BackHousing",
        "FrontHousing",
        "BLTouchSupport",
        "PartCoolingSupport",
    ]
]