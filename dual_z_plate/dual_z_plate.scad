use <components.scad>
use <3rdparty/thingiverse/thingiverse.scad>

module SecondZPlate() {
    d=8;
    h=8;
    w=13.03;
    pos = [38.25,-15.41,67];
    difference() {
        union() {
            rotate([90,0,-1]) ZAxisSupport();
            translate(pos) difference() {
                hull() {
                    cube([w,10,h]);
                    translate([d/2,0,h]) rotate([-90,0,0]) cylinder(h=10, d=d);
                    translate([w-d/2,0,h]) rotate([-90,0,0]) cylinder(h=10, d=d);
                }
                translate([0,7,8]) rotate([0,90,0]) {
                    // Wire space
                    cylinder(d=10, h=w);
                    translate([-5,0,0]) cube([10,10,w]);
                    translate([-10,-5,0]) cube([10,10,w]);
                }
            }
        }
        // Cable ties hole
        translate(pos) rotate([0,90,0]) translate([-5,5,w/2-1.5]) difference() {
            cylinder(d=13, h=3);
            cylinder(d=11, h=3);
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