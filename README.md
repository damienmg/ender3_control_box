# Ender 3 Control Box

This is a 3D printable control box to replace the mainboard enclosure. This enclosure contains:

- A [Raspberry Pi 3B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) for running OctoPrint,
- A [BigTreeTech SKR 1.3 main board](https://github.com/bigtreetech/BIGTREETECH-SKR-V1.3),
- (optional) [A Google AIY Audio Hat](https://aiyprojects.withgoogle.com/voice-v1/) with Speaker and microphone,
- 2 LM2596 Step down converter for providing 12V for the lights and 5V for the raspberry Pi,
- 3 5V relay switch modules controlling the printer, the lights and a fan for the raspberry Pi.

This installation is controlled using an OctoPrint plugin available at
[damienmg/OctoPrint-ControlBox](https://github.com/damienmg/OctoPrint-ControlBox).

This repository contains the design files in [OpenSCAD](https://openscad.org), the
main entry point is at [control_box/control_box.scad](control_box/control_box.scad).

All parameters for this box can be changed in [control_box/params.scad](control_box/params.scad). Building all the
files in the good orientation for printing can be done using [Bazel](https://bazel.build)
with `bazel build ...` (Linux only), then the resulting STL can be found in
`bazel-bin/control_box`. The top of the box has 2 STLs that can be combined following
[this tutorial](https://medium.com/@damien.martin.guillerez/multi-filament-print-with-a-single-extruder-using-prusaslicer-2e0746348cdd?source=friends_link&sk=541dcda7cd469b502874ed76e266267e).

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
