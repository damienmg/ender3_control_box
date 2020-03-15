use <components.scad>
include <external/NopSCADlib/lib.scad>
use <3rdparty/thingiverse/thingiverse.scad>
include <params.scad>

module M3_screw_in(h=3) {
    cylinder(h=h, d=2.5, $fn=50);
    translate([0,0,-0.5]) cylinder(h=2, d1=3.5, d2=2.5, $fn=50);
}

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
                    translate([66.5,-1.5,0]) cylinder(r=2, h=45.2);
                    translate([66.5,36.5,0]) cylinder(r=2, h=45.2);
                }
            }
            hull() {
                translate([30,14, 22.6]) rotate([0,-90,0]) rounded_rectangle([45.2,31,2], r=2);
                translate([12,-12,0]) rotate([0,-90,0]) rounded_rectangle([45.2,42, 12], r=2, xy_center=false, center=false);
            }
            translate([24.5,28.9,42.2]) rounded_rectangle([41.5,42,3], r=6, xy_center=false, center=false);
        }
        // Screw
        translate([34.5, 23.5, 0]) {
            cylinder(d=6, h=5, $fn=30);
            translate([0,0,5]) cylinder(d=9, h=15.5, $fn=30);
        }
        translate([48.5, 23.5, 0]) {
            cylinder(d=6, h=5, $fn=30);
            translate([0,0,5]) cylinder(d=9, h=15.5, $fn=30);
        }
        // Place for X carriage wheel screw
        translate([45, 36, -2.2]) sphere(d=13, $fn=50);
        translate([5, 36, -2.2]) hull() {
            sphere(d=13, $fn=50);
            translate([-7,1.25,7.5]) rotate([90,0,0]) rounded_rectangle([2,2,6], r=0.5, center=false, xy_center=false);
            translate([5,1,1.75]) rotate([90,0,0]) rounded_rectangle([2,2,2], r=0.5, center=false, xy_center=false);
        }
        translate([25, -4, 0]) {
            cylinder(d=10, h=6, $fn=50);
            translate([0,0,6]) cylinder(d1=10, d2=5, h=3, $fn=50);
        }
        // Heatsink air vent
        union() {
            hull() {
                translate([10,-9.25,0]) rotate([0,-90,0]) rounded_rectangle([40.75,40.5,10], r=3, xy_center=false, center=false);
                translate([13,10.5,20.5]) rotate([0,-90,0]) cylinder(d=40, h=3);
            }
            hull() {
                translate([13,10.5,20.5]) rotate([0,-90,0]) cylinder(d=40, h=3);
                translate([30,12.5,20.5]) rotate([0,-90,0]) rotate([0,0,0]) rounded_rectangle([23,23,3], r=3, xy_center=true, center=false);
            }
            hull() {
                translate([30,12.5,20.5]) rotate([0,-90,0]) rotate([0,0,0]) rounded_rectangle([23,23,3], r=3, xy_center=true, center=false);
                translate([42,26,20.5]) rotate([90,0,0]) rounded_rectangle([12,26,26], r=3, xy_center=true, center=false);
            }
            hull() {
                translate([42,26,20.5]) rotate([90,0,0]) rounded_rectangle([12,26,26], r=3, xy_center=true, center=false);
                translate([70,4.5,6]) rotate([0,-90,0]) rounded_rectangle([34,23,2], r=3, xy_center=false, center=false);
            }
            translate([41.5,30,20.5]) rotate([90,0,0]) cylinder(d=17,h=28);
            translate([41.5,25,20.5]) rotate([90,0,0]) cylinder(d=22,h=28);
        }
        // Space for the BMG
        translate([45.3,33.375,20.2]) union() {
            translate([0,0,4.5]) rotate([90,0,0]) rounded_rectangle([38,30,9.25], $fn=2);
            translate([0,0,17]) cube([42,9.25,10], center=true);
        }
        // 4 screw hole (M3 so 2.5 diameter, h=15) to attach the 4010 fan
        translate([11.3,-9,0.5]) {
            translate([0,4,4]) rotate([0,90,0]) M3_screw_in(10);
            translate([0,36,4]) rotate([0,90,0]) M3_screw_in(10);
            translate([0,4,36]) rotate([0,90,0]) M3_screw_in(10);
            translate([0,36,36]) rotate([0,90,0]) M3_screw_in(10);
        }
        // Hole for the stepper motor
        translate([24.2,28.5,42.1]) {
            translate([21.15, 21.15, 0]) cylinder(d=22.4, h=3.2);
            translate([21.15-15.5, 21.15-15.5, 0]) cylinder(d=3.5, h=3.2);
            translate([21.15-15.5, 21.15+15.5, 0]) cylinder(d=3.5, h=3.2);
            translate([21.15+15.5, 21.15+15.5, 0]) cylinder(d=3.5, h=3.2);
            translate([21.15+15.5, 21.15-15.5, 0]) cylinder(d=3.5, h=3.2);
        }
        // Passage for the 4010 fan wire
        translate([6, 18.5, 0.5])
            rotate([90,0,0]) rounded_rectangle([12,2,50], r=0.5);
        // Screw hole for fixing to the X-carriage
        translate([23.5, 33.65, 0]) {
            cylinder(d=3.5, h=10);
            translate([0,0,5]) cylinder(d=6, h=15.5);
        }

        // 2 screw way to attach both part
        translate([16, 33, 0]) {
            translate([0,0,20.5]) rotate([0,180,0]) M3_screw_in(20.5);
            translate([0,0,20.5]) cylinder(d=3.5, h=26);
            translate([0,0,24]) cylinder(d=6, h=22);
        }
        translate([63.5, 0, 0]) {            
            translate([0,0,20.5]) rotate([0,180,0]) M3_screw_in(20.5);
            translate([0,0,20.5]) cylinder(d=3.5, h=26);
            translate([0,0,24]) cylinder(d=6, h=22);
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
        translate([45,22.5,45.5]) rotate([0,180,0]) M3_screw_in(5.5);
        // Attach for the wire guide
        translate([63.5,30.5,0]) M3_screw_in(6);
        // Bl-Touch support screw in
        translate([74.19,32.5,20.5]) rotate([0,-90,0]) M3_screw_in(8);
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
        translate([-4.55,-4.65,1]) rotate([0,180,0]) M3_screw_in(10);
    }
}

module BackHousing() {
    difference() {
        HousingFrame();
        translate([0,-20,20.5]) cube([100,100,100]);
    }
    // BlTouch Support's support
    translate([68.19,37,20.5]) difference() {
        rotate([90,0,0]) linear_extrude(9.5) {
            polygon([
                [-1.8,-5.5],
                [-1.8,5.5],
                [5.6,2.1],
                [5.6,-2.1],
            ]);
        }
        translate([6,-4.5,0]) rotate([0,-90,0]) M3_screw_in(8);
        // Clearance for the Front Housing
        translate([-1.8,-8.5,0]) cube([2.3, 8.5, 5.6]);
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

module PositionedBLTouchSupport() {
    translate([5.2,-132.5,-71.5] + BLTOUCH_OFFSET) {
        rotate([90,0,90]) BLTouchSupport();
    }
}

module PartCoolingSupport() {
    rotate([0,-90,0]) difference() {
        union() {
            difference() {
                rotate([90,0,0]) rounded_rectangle([10,11,24], r=1, center=false, xy_center=false);
                translate([0,-38.9,-15]) cube([20,20,20]);
                translate([0,-42.1,-12]) cube([20,20,20]);
            }
            translate([0,-19.1,0]) rotate([40,0,0]) rounded_rectangle([10,6,20], r=1, center=false, xy_center=false);
            rotate([90,0,0]) rounded_rectangle([18,11,10], r=1, center=false, xy_center=false);
        }
        rotate([-50,0,0]) translate([5.2,-28.2,-15]) {
            M3_screw_in(h=20);
            translate([0,0,4.1]) cylinder(d=6, h=2.3, $fn=6);
        }
        translate([14,-18,5.5]) rotate([-90,0,0]) cylinder(d=3.5, h=20);
        translate([14,-26,5.5]) rotate([-90,0,0]) cylinder(d=6, h=20);
    }
}

module PositionedPartCoolingSupport() {
    translate([6,0.3,-32]) {
        rotate([0,90,0]) PartCoolingSupport();
    }
}

module CantileverSupport(length) {
    linear_extrude(length) polygon([
        [0, 0],
        [1.6, 2],
        [1.9, 4.2],
        [0, 4.2]
    ]);
}

module Cantilever(length) {
    linear_extrude(length) difference() {
        polygon([
            [1, 0],
            [1.5, 0.4],
            [2.25, 4.5],
            [0.5, 4.5],
            [0.5, 4.75],
            [2.25, 6],
            [3, 6],
            [3, 0]
        ]);
        translate([1, 0.5]) circle(r=0.5, $fn=30);
    };
}

module WireGuide(l=60, w=12, h=12, space=20, w2 = 23, len2 = 27) {
    difference() {
        union() {
            translate([0,20,-2]) rotate([90,0,0]) rounded_rectangle([w,h+2, l+20], r=3, center=false, xy_center=false);
        }
        translate([0,-l,h-2.5]) cube([w,l,2.5]);
        translate([1.5,0,1.5]) rotate([90,0,0]) rounded_rectangle([w-3,h,l], r=2, center=false, xy_center=false);
        for(i=[space/2:space:l-space/2]) {
            translate([w/2,-i,w/2+4]) {
                rotate([90,0,0]) cylinder(d=w+4, h=2.5);
                rotate([90,0,0]) difference() {
                    cylinder(d=w+14, h=2.5);
                    cylinder(d=w+11, h=2.5);
                }
            }
        }
        translate([0,-4,w+1.5]) rotate([0,90,0]) rounded_rectangle([w,14+w,w], r=3, center=false, xy_center=false);
        translate([5.5,14.5,-5]) cylinder(d=3.5, 10);
    }
}

module PositionedWireGuide() {
    translate([44,47.5,-4])
        rotate([-90,0,180])
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