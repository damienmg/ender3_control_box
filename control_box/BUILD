#  Copyright 2019 Damien Martin-Guillerez <damien.martin.guillerez@gmail.com>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

load("//3rdparty/openscad:openscad.bzl", "openscad_library", "openscad_artifact")

openscad_library(
    name = "colors",
    srcs = ["colors.scad"],
)

openscad_library(
    name = "control_box_component_positions",
    srcs = ["control_box_component_positions.scad"],
)

openscad_library(
    name = "params",
    srcs = ["params.scad"],
    deps = [":control_box_component_positions"],
)

openscad_library(
    name = "control_box_components",
    srcs = ["control_box_components.scad"],
    deps = [
        ":control_box_component_positions",
        ":colors",
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
        ":colors",
        ":params",
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
