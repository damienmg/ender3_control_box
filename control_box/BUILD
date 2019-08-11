load("//3rdparty/openscad:openscad.bzl", "openscad_library", "openscad_artifact")

openscad_library(
    name = "control_box_component_positions",
    srcs = ["control_box_component_positions.scad"],
)

openscad_library(
    name = "control_box_components",
    srcs = ["control_box_components.scad"],
    deps = [
        ":control_box_component_positions",
        "//3rdparty/AIYVoiceKit",
        "//3rdparty/BuckConverter",
        "//3rdparty/Fan",
        "//3rdparty/RaspberryPi_3B_Plus",
        "//3rdparty/RelaySwitch",
        "//3rdparty/SKR1.3",
    ],
)

openscad_library(
    name = "control_box",
    srcs = ["control_box.scad"],
    deps = [
        ":control_box_components",
        ":control_box_component_positions",
        "//3rdparty/Ender3",
        "//3rdparty/FanTunnel",
    ],
)

openscad_artifact(
    name = "control_box_front",
    module = "ScreenBoxFront",
    deps = ["control_box"],
)

openscad_artifact(
    name = "control_box_back",
    module = "ScreenBoxBack",
    deps = ["control_box"],
)

openscad_artifact(
    name = "control_box_top",
    module = "rotate([180,0,0]) ScreenBoxTop",
    deps = ["control_box"],
)

openscad_artifact(
    name = "control_box_top_logo",
    module = "rotate([180,0,0]) ScreenBoxTopLogo",
    deps = ["control_box"],
)

openscad_artifact(
    name = "endcap",
    module = "rotate([-90,0,0]) Endcap",
    deps = ["control_box"],
)

openscad_artifact(
    name = "pcb_pin",
    module = "PCBPin",
    deps = ["control_box"],
)

openscad_artifact(
    name = "raspberry_pi_standoff",
    module = "RaspberryPiStandoff",
    deps = ["control_box"],
)
