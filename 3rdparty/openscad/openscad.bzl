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

"""Compilation units for building OpenSCAD artifacts."""

# TODO: Better documentation
# TODO: Preprocess OpenSCAD file to make their writing easier (e.g. add includes / use. Support for objects).

OpenSCADLibraryProvider = provider()

def _module_file(ctx):
    file = ctx.actions.declare_file("%s.scad" % ctx.label.name)
    ctx.actions.write(
        file,
        "%s\n%s();\n" % (
            "\n".join([
                "use <%s>" % f.path
                for d in ctx.attr.deps
                if OpenSCADLibraryProvider in d
                for f in d[OpenSCADLibraryProvider].includes
            ]),
            ctx.attr.module if ctx.attr.module else ctx.label.name,
        ),
    )
    return file

def _srcs(ctx, src = None):
    direct = []
    if hasattr(ctx.attr, "srcs"):
        direct.extend(ctx.files.srcs)
    if src:
        direct.append(src)
    transitive = []
    for d in ctx.attr.deps:
        if OpenSCADLibraryProvider in d:
            transitive.append(d[OpenSCADLibraryProvider].srcs)
        else:
            direct.append(d.file)
    return depset(direct = direct, transitive = transitive)

def _lib_impl(ctx):
    return [OpenSCADLibraryProvider(srcs = _srcs(ctx), includes = ctx.files.srcs)]

def _artifact_impl(ctx):
    if ctx.attr.src and ctx.attr.module:
        fail("Cannot specify both src and module at the same time")
    if ctx.attr.src:
        src = ctx.file.src
    else:
        src = _module_file(ctx)
    inputs = _srcs(ctx, src)
    args = ctx.actions.args()
    args.add("-o")
    args.add(ctx.outputs.out.path)
    if ctx.attr.type == "png":
        args.add("--render")
    if ctx.attr.defines:
        args.add("-D")
        args.add_all(["%s=%s" % (k, v) for k, v in ctx.attr.defines])
    args.add(src.path)
    ctx.actions.run(
        outputs = [ctx.outputs.out],
        inputs = inputs,
        executable = ctx.executable._openscad,
        arguments = [args],
        mnemonic = "OpenSCAD",
        env = {"OPENSCADPATH": ":".join([".", ctx.bin_dir.path, ctx.genfiles_dir.path])},
    )

openscad_library = rule(
    implementation = _lib_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [
            ".scad",
            ".stl",
            ".off",
            ".dxf",
            ".Scad",
            ".Stl",
            ".Off",
            ".Dxf",
            ".SCAD",
            ".STL",
            ".OFF",
            ".DXF",
        ]),
        "deps": attr.label_list(providers = [OpenSCADLibraryProvider]),
    },
)

openscad_artifact = rule(
    implementation = _artifact_impl,
    attrs = {
        "deps": attr.label_list(providers = [OpenSCADLibraryProvider]),
        "src": attr.label(allow_files = [".scad"], single_file = True, mandatory = False),
        "module": attr.string(),
        "type": attr.string(default = "stl", values = ["stl", "off", "dxf", "csg"]),
        "defines": attr.string_dict(default = {}),
        "_openscad": attr.label(default = "@org_openscad//:org_openscad", executable = True, cfg = "host"),
    },
    outputs = {
        "out": "%{name}.%{type}",
    },
)
