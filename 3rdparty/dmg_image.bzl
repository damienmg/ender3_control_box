#  Copyright 2020 Damien Martin-Guillerez <damien.martin.guillerez@gmail.com>
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
"""A quick rule for downloading an DMG and extracting it into a binary."""

def dmg_image_implementation(rctx, urls, app, binary=None, sha256=None):
    binary = binary or app
    rctx.download(
        url = urls,
        output = "image.dmg",
        sha256 = sha256,
        executable = True,
    )
    results = rctx.execute(["hdiutil", "attach", "image.dmg"])
    mount_point = results.stdout.split("\n")[-2].split("S", 1)[1].strip()
    rctx.execute(["cp", "-fr", "%s/%s.app" % (mount_point, app), "."], quiet=False)
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
exec "${RUNFILES}/%s.app/Contents/MacOS/%s" "$@"
""" % (rctx.name, app, binary), executable = True)
    rctx.file("BUILD", """
sh_binary(
    name = "{name}",
    srcs = ["run.sh"],
    data = glob(["{app}.app/**"]),
    visibility = ["//visibility:public"],
)
""".format(name=rctx.name, app=app))
    rctx.execute(["hdiutil", "detach", "-quiet", mount_point])

def _impl(rctx):
    dmg_image_implementation(
        rctx=rctx,
        urls=rctx.attr.urls,
        app=rctx.attr.app,
        binary=rctx.attr.binary,
        sha256=rctx.attr.sha256,
    )

dmg_image_repository = repository_rule(
    implementation = _impl,
    attrs = {
        "urls": attr.string_list(mandatory = True),
        "app": attr.string(mandatory = True),
        "binary": attr.string(),
        "sha256": attr.string(),
    },
)
