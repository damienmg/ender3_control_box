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

load("//3rdparty:app_image.bzl", "app_image_repository")

def openscad():
    app_image_repository(
        name = "org_openscad",
        urls = ["https://files.openscad.org/OpenSCAD-2019.05-x86_64.AppImage"],
        binary = "/usr/bin/openscad",
        sha256 = "3d3176b10ce8bd136950fa36061f824eee5ffa23cdf5dd91bcf89f5ece6f2592",
    )
