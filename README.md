# My Ender 3's upgrade

This repository contains some upgrade for the Creality
Ender 3, namely:

- A [3D printable control box](control_box/README.md) to replace the mainboard enclosure by an enclosure containing a [Raspberry Pi 3B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/), a [BigTreeTech SKR 1.3 main board](https://github.com/bigtreetech/BIGTREETECH-SKR-V1.3), and some more.
- A [PSU Cover](psu_sonoff_cover/README.md) for the Creality Ender-3 that can hold the card of a Sonoff Basic R3.

All the design files in this repository are for [OpenSCAD](https://openscad.org). Building all the
files in the good orientation for printing can be done using [Bazel](https://bazel.build)
with `bazel build ...` (Linux only), then the resulting STL can be found in
`bazel-bin/`.

## License

The license of the original sources file of this document are covered by the
[Apache License 2.0](LICENSE). However the resulting schema link in various
[Creative Commons](https://creativecommons.org) licenses. Because the complexity
of licensing law it is unclear wether the resulting output file would be covered
as a library or a derivative. If it is a derivative, then it should be probably
covered by a [CC-BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)
license. The third party directory of this repository is a collection
and each file has its own license, please refer to each README file for the
exact license.
