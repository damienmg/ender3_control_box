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

workspace(name = "com_github_damienmg_ender3_control_box")

load("//3rdparty/openscad:repo.bzl", "openscad")
openscad()

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "NopSCADlib",
    urls = ["https://github.com/nophead/NopSCADlib/archive/6f93b6af9ae66e35d3a901fc7404460150c78127.zip"],
    sha256 = "794aa653ec3bc00c7d8bede3793801339600ba348052250203d1773a853ce487",
    build_file = "@//tools:nopscadlib.BUILD",
    strip_prefix = "NopSCADlib-6f93b6af9ae66e35d3a901fc7404460150c78127"
)