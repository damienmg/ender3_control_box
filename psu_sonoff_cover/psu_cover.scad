/*
 * Copyright 2019 Damien Martin-Guillerez <damien.martin.guillerez@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

include <params.scad>

module PSUCoverBoundingBox(height=70, width=115, depth=54, corner_radius=10, fillet=0.5) {
    minkowski() {
       union() translate([-width/2, -depth/2+fillet, height]) rotate([-90,0,0]) hull() {
            translate([width-1-fillet, 0, 0]) cube([1, 1, depth-2*fillet]);
            translate([width-1-fillet, height-1-fillet, 0]) cube([1, 1, depth-2*fillet]);
            translate([fillet, height-1-fillet, 0]) cube([1, 1, depth-2*fillet]);
            translate([corner_radius, corner_radius, 0]) cylinder(r=corner_radius-fillet, h=depth-2*fillet, $fn=50);
        }
        sphere(fillet, $fn=50);
    }
}

module PSUCover(height=70, width=115, depth=54, corner_radius=10, fillet=0.5, thickness=2, psu_width=115) {
    operture = 41;
    difference() {
        union() {
            difference() {
                PSUCoverBoundingBox(height, width, depth, corner_radius, fillet);
                translate([0,0,thickness]) PSUCoverBoundingBox(height+1, width-2*thickness, depth-2*thickness, 1, fillet);
            }
            translate([psu_width-width/2-thickness, -depth/2+thickness, height-15])
                cube([width-psu_width, depth-2*thickness, 15+fillet]);
            // Chamfer to make the upper block printable.
            translate([psu_width-width/2-thickness, -depth/2+thickness, height-15])
                rotate([-90,0,0]) linear_extrude(depth-2*thickness)
                    polygon([
                        [0,0],
                        [width-psu_width, 0],
                        [width-psu_width, 17],
                    ]);
        }
        translate([-width/2, -depth/2+thickness, height-operture]) cube([2*thickness, depth-2*thickness, operture]);
        h=width-psu_width+thickness;

        translate([width/2-h,1,height-8]) rotate([0, 90, 0]) {
            translate([0, 12.5, 0]) cylinder(r=2.3, h=h, $fn=100);
            translate([0, -12.5, 0]) cylinder(r=2.3, h=h, $fn=100);
            translate([0,12.5,thickness]) cylinder(r=6, h=h-thickness, $fn=100);
            translate([0,-12.5,thickness]) cylinder(r=6, h=h-thickness, $fn=100);
        }
        // Cable out
        translate([0,depth/2,15]) rotate([90,0,0]) hull() {
            cylinder(h=thickness, d=20);
            translate([10,0,0]) cylinder(h=thickness, d=20);
        }
    }
}

module SonoffEnclosure(pos=[0,0,0], rotation=[0,0,0], h=4, thickness=2) {
    difference() {
        union() {
            children();
            translate(pos) rotate(rotation) {
                translate([-3*thickness-0.2,-1,-thickness-0.2]) cube([3*thickness, 35.4, thickness+h+0.2]);
                translate([69.2-2*thickness,-1,-thickness-0.2]) cube([3*thickness, 35.4, thickness+h+0.2]);
                // Front and back are set to not colide with board components
                translate([-0.2,-1, 2]) cube([2.5, 2*thickness, h/2]);
                translate([-0.2,-1, -thickness-0.2]) cube([2.5, 2*thickness, h/2]);
                translate([69.2-2*thickness-8,-1, 2]) cube([8, 2*thickness, h/2]);
                translate([69.2-2*thickness-8,-1, -thickness-0.2]) cube([8, 2*thickness, h/2]);
                // translate([-thickness-0.2,-1,-thickness-0.2]) cube([69.4, h, thickness]);
            }
        }
        translate(pos) rotate(rotation) {
            // Control button hole
            translate([37.8,6.3,17]) cylinder(d=3.5, h=4, $fn=100);
            // Light semi hole
            translate([48.4,6.2,16.5]) cylinder(d=3.5, h=4, $fn=100);
            // Screw in holes (M2)
            translate([-1.5*thickness-0.1, 25, thickness/2]) rotate([-90,0,0]) cylinder(d=1.7, h=10, $fn=30);
            translate([69.2-thickness/2, 25, thickness/2]) rotate([-90,0,0]) cylinder(d=1.7, h=10, $fn=30);
        }
    }
}

module SonoffEnclosureCap(pos=[0,0,0], rotation=[0,0,0], h=4, thickness=2) {
    translate(pos) rotate(rotation) {
        difference() {
            union() {
                translate([-3*thickness-0.2,34.4,-thickness-0.2]) cube([6*thickness+65.4, thickness, thickness+h+0.2]);
                translate([0.5,31.4,-thickness-0.2]) cube([3.5,3,thickness+h+0.2]);
                translate([4,31.4,-thickness-0.2]) cube([3.5,3,thickness]);
                translate([4,31.4,h-thickness]) cube([3.5,3,thickness]);
                translate([55,31.4,-thickness-0.2]) cube([3.5,3,thickness]);
                translate([55,31.4,h-thickness]) cube([3.5,3,thickness]);
            }
            // Screw in holes (M2)
            translate([-1.5*thickness-0.1, 28, thickness/2]) rotate([-90,0,0]) cylinder(d=2, h=10, $fn=30);
            translate([69.2-thickness/2, 28, thickness/2]) rotate([-90,0,0]) cylinder(d=2, h=10, $fn=30);
        }
    }
}

module PowerPlug(pos=[0,0,0], rotation=[0,0,0], h=27, w=56, d=10, thickness=2, fillet=1, hole_depth=10) {
    difference() {
        children();

        translate(pos) rotate(rotation) {
            translate([-w/2+3.5, -hole_depth/2, -h/2-0.5]) cube([w-7,hole_depth,h+1]);
            translate([0, hole_depth/2, h/2+d/2+1.5]) rotate([90,0,0]) cylinder(d=2.6, h=hole_depth, $fn=50);
            translate([0, hole_depth/2, -h/2-d/2-1.5]) rotate([90,0,0]) cylinder(d=2.6, h=hole_depth, $fn=50);
        }
    }
}

module SonoffBoardMock(pcb=false) {
    // PCB
    difference() {
        intersection() {
            if (pcb) translate([-6.4, -8.3, 0]) scale([0.077, 0.077, 0.0157]) surface("/home/dmg/Downloads/1000px-Sonoff-view.png");
            cube([64.7, 34, 1.57]);
        }
        translate([0,31,0]) cube([4.3,3,2]);
    }
    // Bigest components mock:
    translate([0,0,1.57]) {
        // Switch
        translate([16.7, 13.2,0]) cube([10, 17.7, 15.5]);
        // Power inductor EE10
        translate([24.5, 1.7, 0]) cube([10, 9.7, 8.3]);
        // Caps
        translate([15.9, 4.9, 0]) cylinder(d=8, h=8.3, $fn=30);
        translate([31.5, 16, 0]) cylinder(d=8, h=8.3, $fn=30);
        // Screw Terminals
        translate([1, 11.9, 0]) cube([6.5, 10, 9]);
        translate([57.3, 16, 0]) cube([6.5, 10, 9]);
        // Led
        translate([48.4, 6.2, 0]) cylinder(d=3, h=17, $fn=50);
        // Button
        translate([37.8,6.3,0.5]) {
            cube([4.6,6.4,1], center=true);
            translate([0,0,0.5]) cylinder(d=3, h=20.5, $fn=50);
        }
    }
}

module FullPSUCover() {
    SonoffEnclosure(pos=SONOFF_POS, rotation=SONOFF_ROTATION)
        PowerPlug(POWER_PLUG_POS, rotation=POWER_PLUG_ROTATION)
            PSUCover(height=HEIGHT, width=WIDTH);
}

module Scene() {
    translate([90.5,124+WIDTH/2,127.5-HEIGHT]) {
        rotate([0,0,90]) {
            FullPSUCover();
            SonoffEnclosureCap(SONOFF_POS, SONOFF_ROTATION);
            %translate(SONOFF_POS) rotate(SONOFF_ROTATION) SonoffBoardMock(false);
        }
    }
}

Scene();