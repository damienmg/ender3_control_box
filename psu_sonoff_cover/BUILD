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
    name = "psu_sonoff_cover",
    srcs = [
        "psu_cover.scad",
        "params.scad",
    ],
)

openscad_artifact(
    name = "psu_cover",
    module = "FullPSUCover",
    deps = [":psu_sonoff_cover"],
)

openscad_artifact(
    name = "psu_cover_sonoff_cap",
    module = "rotate([-90,0,0]) SonoffEnclosureCap",
    deps = [":psu_sonoff_cover"],
)

openscad_artifact(
    name = "sonoff_basic_r3",
    module = "SonoffBoardMock",
    deps = [":psu_sonoff_cover"],
)