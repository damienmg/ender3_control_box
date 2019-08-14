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
