use <components.scad>
use <3rdparty/thingiverse/thingiverse.scad>

module CableTieHole(d=13, h=3, thickness=2) {
    difference() {
        cylinder(d=d, h=h);
        cylinder(d=d-thickness, h=h);
    }
}

module SecondZPlate() {
    $fn=50;
    d=8;
    h=8;
    w=13.03;
    w2=49.32;
    h2=50;
    pos = [38.25,-15.41,67];
    difference() {
        union() {
            rotate([90,0,-1]) ZAxisSupport();
            translate(pos) difference() {
                union() {
                    translate([w-w2,0,0]) hull() {
                        cube([w2,10,h]);
                        translate([w2-d/2,0,h]) rotate([-90,0,0]) cylinder(h=10, d=d);
                        translate([0,0,h]) cube([10,10,d/2]);
                    }
                    translate([2*w-w2,0,0]) cube([w2-w, 10, h]);
                    translate([w-w2,0,10]) hull() {
                        cube([w, 10, h2-20]);
                        translate([0,0,h2-15]) cube([5,5,5]);
                        translate([w-d/2, 0, h2-10-d/2]) rotate([-90,0,0])
                            cylinder(h=5, d=d);
                        translate([0, 10-d/2, h2-10-d/2]) rotate([0,90,0])
                            cylinder(h=5, d=d);
                    }
                    translate([w-w2,-24,-24]) difference() {
                        cube([w2-w, 34, 26]);
                        translate([0,3.8,0]) rotate([51.5,0,0]) translate([0,3.5,0]) cube([w2-w, 30, 30]);
                        translate([0,0.3,7.4]) rotate([0,90,0]) cylinder(d=14.7, h=w2-w);
                    }
                    translate([2*w-w2,0,h+d/2]) cube([d/2,2,d/2]);
                }
                translate([1.5*w-w2,7,8]) rotate([0,90,0]) {
                    // Wire space
                    cylinder(d=10, h=w2-w/2);
                    translate([-5,0,0]) cube([10,10,w2-w/2]);
                    translate([-10,-5,w/2]) cube([10,10,w2-w]);
                }
                translate([w-w2+7,7,8]) {
                    cylinder(d=10, h=w2);
                    translate([-5,0,0]) cube([10,10,w2]);
                    translate([0,-5,0]) cube([10,10,w2]);
                }
                translate([2*w-w2+d/2,0,h+d]) rotate([-90,0,0]) cylinder(d=d, h=2);
                translate([w-w2+7,7,8]) {
                    sphere(d=10);
                    rotate([-90,0,0]) cylinder(d=10,h=10);
                }
            }
        }
        // Cable ties hole
        translate(pos) {
            rotate([0,90,0]) translate([-5,5,w/2-1.5]) {
                CableTieHole();
                translate([0,0,-24]) CableTieHole();
            }
            translate([-w2+w+3.5,0.5,h2-w/2-1.5]) {
                CableTieHole(d=17);
                translate([0,0,-24]) CableTieHole(d=17);
            }
        }
    }
}

module PositionedSecondZPlate() {
    translate([-67.5,270,203]) rotate([-90,180,180]) SecondZPlate();
}

module Scene() {
    Components();
    PositionedSecondZPlate();
}

Scene();