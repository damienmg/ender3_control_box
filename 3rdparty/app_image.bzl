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

"""A quick rule for downloading an AppImage and executing it."""
# Note: only compatible with Linux.

def _impl(rctx):
    rctx.download(
        url = rctx.attr.urls,
        output = "AppImage.bin",
        sha256 = rctx.attr.sha256,
        executable = True,
    )
    rctx.execute(["./AppImage.bin", "--appimage-extract"])
    rctx.file("run.sh", """#!/bin/bash
WORKSPACE="%s"
get_runfiles_dir() {
    (
        if [ -d "${BASH_SOURCE[0]}.runfiles" ]; then
            cd "${BASH_SOURCE[0]}.runfiles/${WORKSPACE}"
        elif ! [ -d "${PWD}/../${WORKSPACE}" ]; then
            cd "$(readlink ${BASH_SOURCE[0]}).runfiles/${WORKSPACE}"
        fi
        pwd -P
    )
}

RUNFILES="${RUNFILES:-${JAVA_RUNFILES:-$(get_runfiles_dir)}}"
exec "${RUNFILES}"/squashfs-root%s "$@"
""" % (rctx.name, rctx.attr.binary), executable = True)
    rctx.file("BUILD", """
sh_binary(
    name = "%s",
    srcs = ["run.sh"],
    data = glob(["squashfs-root/**"]),
    visibility = ["//visibility:public"],
)
""" % rctx.name)

app_image_repository = repository_rule(
    implementation = _impl,
    attrs = {
        "urls": attr.string_list(mandatory = True),
        "binary": attr.string(default = "/AppRun"),
        "sha256": attr.string(),
    },
)
