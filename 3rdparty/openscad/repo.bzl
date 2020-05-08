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

load("//3rdparty:app_image.bzl", "app_image_implementation")
load("//3rdparty:dmg_image.bzl", "dmg_image_implementation")

def _impl(rctx):
    os_name = rctx.os.name.lower()
    if os_name.startswith("mac os"):
        return dmg_image_implementation(
            rctx,
            urls = ["https://files.openscad.org/OpenSCAD-%s.dmg" % rctx.attr.version],
            app = "OpenSCAD",
            sha256 = rctx.attr.sha256["macos"] if "macos" in rctx.attr.sha256 else None,
        )
    elif os_name.startswith("linux"):
        return app_image_implementation(
            rctx,
            urls = ["https://files.openscad.org/OpenSCAD-%s-x86_64.AppImage" % rctx.attr.version],
            binary = "/usr/bin/openscad",
            sha256 = rctx.attr.sha256["linux"] if "linux" in rctx.attr.sha256 else None,
        )
    else:
        fail("Unsupported operating system: " + os_name)

_openscad_repository = repository_rule(
    implementation = _impl,
    attrs = {
        "version": attr.string(),
        "sha256": attr.string_dict(),
    },
)

def openscad():
    _openscad_repository(
        name = "org_openscad",
        version = "2019.05",
        sha256 = {
            "macos": "df6f6f3d34ac0d07f533ec4ccf59082189fb37c0276c1b8df651291e2509420e",
            "linux": "3d3176b10ce8bd136950fa36061f824eee5ffa23cdf5dd91bcf89f5ece6f2592",
        }
    )
