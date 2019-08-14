# Ender 3 Control Box

This is a 3D printable control box to replace the mainboard enclosure. This enclosure contains:

    - A [Raspberry Pi 3B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) for running OctoPrint,
    - A [BigTreeTech SKR 1.3 main board](https://github.com/bigtreetech/BIGTREETECH-SKR-V1.3),
    - (optional) [A Google AIY Audio Hat]() with Speaker and microphone,
    - 2 LM2596 Step down converter for providing 12V for the lights and 5V for the raspberry Pi,
    - 3 5V relay switch modules controlling the printer, the lights and a fan for the raspberry Pi.

This installation is controlled using an OctoPrint plugin available at [damienmg/OctoPrint-ControlBox](https://github.com/damienmg/OctoPrint-ControlBox).

This repository contains the design files in [OpenSCAD](https://openscad.org), the main entry point is at [control_box/control_box.scad].

## License

The license of the original sources file of this document are covered by the
[Apache License 2.0](LICENSE). However the resulting schema link in various
[Creative Commons](https://creativecommons.org) licenses. Because the complexity
of licensing law it is unclear wether the resulting output file would be covered
as a library or a derivative. If it is a derivative, then it should be probably
covered by a [CC-BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode) license. The third party directory of this repository is a collecction
and each file has its own license, please refer to each README file for the
exact license.
