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

package(
    default_visibility = ["//visibility:public"],
    licenses = ["by_exception_only"],  # !!! Non-commercial for 4010 !!!
)

load("//3rdparty/openscad:openscad.bzl", "openscad_library")

openscad_library(
    name = "Fan",
    srcs = [
        "4010/40x40x10 PC Fan.stl",
        "5015/files/5015_Blower_Fan.stl",
        "fan.scad",
    ],
)
