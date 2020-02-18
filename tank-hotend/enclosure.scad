use <components.scad>
include <external/NopSCADlib/lib.scad>
include <params.scad>

module HousingFrame() {
    difference() {
        union() {
            translate([0,-1.5, 0]) {
                hull() {
                    translate([2,2,0]) cylinder(r=2, h=45.2);
                    translate([56,2,0]) cylinder(r=2, h=45.2);
                    translate([66.5,36.5,0]) cylinder(r=2, h=45.2);
                    translate([2,36.5,0]) cylinder(r=2, h=45.2);
                }
                hull() {
                    translate([56,2,0]) cylinder(r=2, h=45.2);
                    translate([65,0,0]) cylinder(r=2, h=45.2);
                    translate([66.5,36.5,0]) cylinder(r=2, h=45.2);
                }
            }
            hull() {
                translate([30,14, 22.6]) rotate([0,-90,0]) rounded_rectangle([45.2,31,2], r=2);
                translate([12,-12,0]) rotate([0,-90,0]) rounded_rectangle([45.2,42, 12], r=2, xy_center=false, center=false);
            }
            translate([24.5,27.9,42.2]) rounded_rectangle([41.5,42,3], r=6, xy_center=false, center=false);
        }
        // Screw
        translate([34.5, 23.5, 0]) {
            cylinder(d=6, h=5, $fn=30);
            translate([0,0,5]) cylinder(d=10, h=3, $fn=30);
        }
        translate([48.5, 23.5, 0]) {
            cylinder(d=6, h=5, $fn=30);
            translate([0,0,5]) cylinder(d=10, h=3, $fn=30);
        }
        // Place for X carriage wheel screw
        translate([45, 36, -2.2]) sphere(d=13, $fn=50);
        translate([5, 36, -2.2]) sphere(d=13, $fn=50);
        translate([25, -4, -2.2]) sphere(d=13, $fn=50);
        // Heatsink air vent
        union() {
            hull() {
                translate([10,-9.25,0]) rotate([0,-90,0]) rounded_rectangle([40.75,40.5,10], r=3, xy_center=false, center=false);
                translate([13,10.5,20.5]) rotate([0,-90,0]) cylinder(d=40, h=3);
            }
            hull() {
                translate([13,10.5,20.5]) rotate([0,-90,0]) cylinder(d=40, h=3);
                translate([30,12.5,20.5]) rotate([0,-90,0]) rotate([0,0,0]) rounded_rectangle([26,26,3], r=3, xy_center=true, center=false);
            }
            hull() {
                translate([30,12.5,20.5]) rotate([0,-90,0]) rotate([0,0,0]) rounded_rectangle([26,26,3], r=3, xy_center=true, center=false);
                translate([42,26,20.5]) rotate([90,0,0]) rounded_rectangle([12,26,26], r=3, xy_center=true, center=false);
            }
            hull() {
                translate([42,26,20.5]) rotate([90,0,0]) rounded_rectangle([12,26,26], r=3, xy_center=true, center=false);
                translate([70,4.5,6]) rotate([0,-90,0]) rounded_rectangle([34,23,2], r=3, xy_center=false, center=false);
            }
            translate([42,28,20.5]) rotate([90,0,0]) cylinder(d=22,h=32);
        }
        // Space for the BMG
        translate([45.3,32.375,20.4]) union() {
            translate([0,0,4.5]) rotate([90,0,0]) rounded_rectangle([38,30,9.25], $fn=2);
            translate([0,0,17]) cube([42,9.25,10], center=true);
        }
        // 4 screw hole (M3 so 2.5 diameter, h=15) to attach the 4010 fan
        translate([10,-9,0.5]) {
            translate([0,4,4]) rotate([0,90,0]) cylinder(h=10, d=2.5);
            translate([0,36,4]) rotate([0,90,0]) cylinder(h=10, d=2.5);
            translate([0,4,36]) rotate([0,90,0]) cylinder(h=10, d=2.5);
            translate([0,36,36]) rotate([0,90,0]) cylinder(h=10, d=2.5);
        }
        // Hole for the stepper motor
        translate([24.2,27.5,42.2]) {
            translate([21.15, 21.15, 0]) cylinder(d=22.4, h=3);
            translate([21.15-15.5, 21.15-15.5, 0]) cylinder(d=3.5, h=3);
            translate([21.15-15.5, 21.15+15.5, 0]) cylinder(d=3.5, h=3);
            translate([21.15+15.5, 21.15+15.5, 0]) cylinder(d=3.5, h=3);
            translate([21.15+15.5, 21.15-15.5, 0]) cylinder(d=3.5, h=3);
        }
        // Passage for the 4010 fan wire
        translate([6, 18.5, 0.5])
            rotate([90,0,0]) rounded_rectangle([12,2,50], r=0.5);
        // Screw hole for fixing to the X-carriage
        translate([23.5, 33.65, 0]) {
            cylinder(d=3.5, h=10);
            translate([0,0,6]) cylinder(d=5, h=14.5);
        }

        // 2 screw way to attach both part
        translate([16, 33, 0]) {
            cylinder(d=2.5, h=20.5);
            translate([0,0,20.5]) cylinder(d=3.5, h=26);
            translate([0,0,24]) cylinder(d=5, h=22);
        }
        translate([63.5, 0, 0]) {
            cylinder(d=2.5, h=20.5);
            translate([0,0,20.5]) cylinder(d=3.5, h=26);
            translate([0,0,24]) cylinder(d=5, h=22);
        }

        // Clearance for the fan shroud
        translate([33.5,-2,48]) hull() {
            translate([0,0,0]) sphere(d=1);
            translate([-10,0,0]) sphere(d=1);
            translate([-10,-8,0]) sphere(d=1);
            translate([0,-8,0]) sphere(d=1);

            translate([0,0,-10]) sphere(d=1);
            translate([-10,0,-10]) sphere(d=1);
            translate([-10,-8,-10]) sphere(d=1);
            translate([0,-8,-10]) sphere(d=1);
        }
        // Blower arm screw hole
        translate([45,21,40]) cylinder(d=2.5, h=5.5);
        // Attach for the wire guide
        translate([63,31.5,0])
          cylinder(d=2.5, h=3);
     }
    // Attach for the fan shroud
    translate([32,-2,37]) difference() {
        union() {
            hull() {
                translate([0.25,1,0]) sphere(d=1);
                translate([-10,1,0]) sphere(d=1);
                translate([-10,-7.5,0]) sphere(d=1);
                translate([0.25,-7.5,0]) sphere(d=1);

                translate([0.25,1,-3]) sphere(d=1);
                translate([-10,0,-3]) sphere(d=1);
                translate([-10,-7.5,-3]) sphere(d=1);
                translate([0.25,-7.5,-3]) sphere(d=1);
            }
            hull() {
                translate([-9.75,0,0]) sphere(d=1.5);
                translate([-9.75,-7.25,0]) sphere(d=1.5);
                translate([-9.75,0,7.25]) sphere(d=1.5);
            }
            hull() {
                translate([0,0.5,0]) sphere(d=1.5);
                translate([0,-7.25,0]) sphere(d=1.5);
                translate([0,0.5,7.25]) sphere(d=1.5);
            }
        }
        translate([-4.55,-4.65,-5]) cylinder(d=2.5, h=10);
    }
    // TODO: path for the wires?
}

module BackHousing() {
    difference() {
        HousingFrame();
        translate([0,-20,20.5]) cube([100,100,100]);
    }
    // BlTouch Support's support
    translate([68.19,35,20.5]) difference() {
        rotate([90,0,0]) linear_extrude(7.5) {
            polygon([
                [0,-5.5],
                [0,5.5],
                [5.6,2.1],
                [5.6,-2.1],
            ]);
        }
        translate([1,-2.5,0]) rotate([0,90,0]) cylinder(d=2.5, h=5);
    }
}
module PositionedBackHousing() {
    translate([-25,45.5,-49]) rotate([90,0,0]) 
        BackHousing();
}

module FrontHousing() {
    rotate([180,0,0]) intersection() {
        HousingFrame();
        translate([0,-20,20.5]) cube([100,100,100]);
    }
}
module PositionedFrontHousing() {
    translate([-25,45.5,-49]) rotate([-90,0,0]) 
        FrontHousing();
}

module BLTouchSupport() {
    difference() {
        hull() {
            translate([0, -9,0]) cylinder(d=8, h=2.5);
            cylinder(d=12, h=2.5);
            translate([0,9,0]) cylinder(d=8, h=2.5);
        }
        translate([0,-9,0]) cylinder(d=3.2, h=2.5);
        translate([0,9,0]) cylinder(d=3.2, h=2.5);
    }
    difference() {
        linear_extrude(20.5) {
            polygon([
                [0.3,-2.125],
                [-4.5,-5],
                [-4.5,-6.25],
                [2.3,-6.25],
                [3.3, -5.25],
                [3.3, 5.25],
                [2.3,6.25],
                [-4.5,6.25],
                [-4.5,5],
                [0.3,2.125],
            ]);
        }
        hull() {
            translate([0.3,0,7.1]) rotate([0,90,0]) cylinder(h=1.5, d=3.12);
            translate([0.3,0,16]) rotate([0,90,0]) cylinder(h=1.5, d=3.12);
        }
        hull() {
            translate([1.8,0,7.1]) rotate([0,90,0]) cylinder(h=1.5, d2=6, d1=3.12);
            translate([1.8,0,16]) rotate([0,90,0]) cylinder(h=1.5, d2=6, d1=3.12);
        }
    }
}

module PositionedBLTouchSupport() {
    translate([16.5,25,-25] + BLTOUCH_OFFSET) {
        BLTouchSupport();
    }
}

module PartCoolingSupport() {
    rotate([0,-90,0]) difference() {
        union() {
            difference() {
                rotate([90,0,0]) rounded_rectangle([10,8,22], r=1, center=false, xy_center=false);
                translate([0,-37.1,-15]) cube([20,20,20]);
                translate([0,-40.1,-12]) cube([20,20,20]);
            }
            translate([0,-17.1,0]) rotate([40,0,0]) rounded_rectangle([10,4,20], r=1, center=false, xy_center=false);
            rotate([90,0,0]) rounded_rectangle([18,8,3], r=1, center=false, xy_center=false);
        }
        rotate([-50,0,0]) translate([5.2,-27.2,-20]) cylinder(d=2.5, h=20);
        translate([14,-18,4]) rotate([-90,0,0]) cylinder(d=3.5, h=20);
    }
}

module PositionedPartCoolingSupport() {
    translate([6,0.3,-32]) {
        rotate([0,90,0]) PartCoolingSupport();
    }
}

module WireGuide(h=40, space=20) {
    rotate([0,180,0]) {
        difference() {
            union() {
                difference() {
                    rotate([90,0,0]) rounded_rectangle([10,10,h], r=2, center=false, xy_center=false);
                    translate([0,-h,6.5]) cube([10,h,10]);
                    translate([1.5,0,1.5]) rotate([90,0,0]) rounded_rectangle([7,7,h], r=2, center=false, xy_center=false);
                }
                translate([0,0,5]) rotate([90,0,0]) rounded_rectangle([1.5,3,h], r=0.7, center=false, xy_center=false);
                translate([8.5,0,5]) rotate([90,0,0]) rounded_rectangle([1.5,3,h], r=0.7, center=false, xy_center=false);
            }
            for(i=[space/2:space:h-space/2]) {
                translate([0,-i,0]) cube([10,2.5, 10]);
            }
        }
        translate([1,0,0]) rotate([90,0,0]) rounded_rectangle([8,1.5,h], r=0.7, center=false, xy_center=false);
        translate([-1.5, 0, 2]) {
            difference() {
                rounded_rectangle([6,6,5.5], r=2, center=false);
                translate([-1.5,-2,0]) rounded_rectangle([6,6,5.5], r=1, center=false);
            }
        }
        translate([11.5, 0, 2]) {
            difference() {
                rounded_rectangle([6,6,5.5], r=2, center=false);
                translate([1.5,-2,0]) rounded_rectangle([6,6,5.5], r=1, center=false);
            }
        }
        difference() {
            translate([0,0,-8.5]) rotate([90,0,0]) rounded_rectangle([10,10,2], r=1, center=false, xy_center=false);
            translate([5,0,-3.5]) rotate([90,0,0]) cylinder(d=3.5, h=3);
        }
        translate([0,-2,0]) cube([2,2,2]);
        translate([8,-2,0]) cube([2,2,2]);
    }
}

module PositionedWireGuide() {
    translate([43,45.5,-14])
        rotate([0,180,180])
            WireGuide();
}

module TankHotEnd() {
    PositionedWireGuide();
    HotEndAssembly();
    PositionedBackHousing();
    PositionedFrontHousing();
    PositionedBLTouchSupport();
    PositionedPartCoolingSupport();
}

TankHotEnd();