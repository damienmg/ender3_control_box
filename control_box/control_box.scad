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
use <../3rdparty/Ender3/ender3.scad>
use <../3rdparty/FanTunnel/fan_tunnel.scad>
use <control_box_components.scad>
include <colors.scad>
include <params.scad>
use <feet.scad>

$fn=50;

// Module to mark all support
module Support() {
    if (GENERATE_SUPPORT) {
        color(SUPPORT_COLOR) {
            union() children();
        }
    }
}

module SupportTopLayers(length, width) {
    intersection() {
        union() {
            // A perimeter.
            linear_extrude(INTERFACE_LAYERS*LAYER_HEIGHT)
                polygon([
                    [0, 0],
                    [width, 0],
                    [width, length],
                    [0, length],
                    [0, 0],
                    [EXTRUSION_WIDTH, EXTRUSION_WIDTH],
                    [width-EXTRUSION_WIDTH, EXTRUSION_WIDTH],
                    [width-EXTRUSION_WIDTH, length-EXTRUSION_WIDTH],
                    [EXTRUSION_WIDTH, length-EXTRUSION_WIDTH],
                    [EXTRUSION_WIDTH, EXTRUSION_WIDTH]
                ]);
            // Add striped pattern
            if (width < length) {
                for (off = [SUPPORT_PATTERN_DISTANCE:SUPPORT_PATTERN_DISTANCE:length+SUPPORT_PATTERN_DISTANCE])
                    linear_extrude(INTERFACE_LAYERS*LAYER_HEIGHT)
                        polygon([
                            [EXTRUSION_WIDTH, off-SUPPORT_PATTERN_DISTANCE],
                            [width-EXTRUSION_WIDTH, off],
                            [width-EXTRUSION_WIDTH, EXTRUSION_WIDTH+off],
                            [EXTRUSION_WIDTH, EXTRUSION_WIDTH+off-SUPPORT_PATTERN_DISTANCE],
                        ]);
            } else {
                for (off = [SUPPORT_PATTERN_DISTANCE:SUPPORT_PATTERN_DISTANCE:width+SUPPORT_PATTERN_DISTANCE])
                    linear_extrude(INTERFACE_LAYERS*LAYER_HEIGHT)
                        polygon([
                            [off-SUPPORT_PATTERN_DISTANCE, EXTRUSION_WIDTH],
                            [off, length-EXTRUSION_WIDTH],
                            [EXTRUSION_WIDTH+off, length-EXTRUSION_WIDTH],
                            [EXTRUSION_WIDTH+off-SUPPORT_PATTERN_DISTANCE, EXTRUSION_WIDTH],
                        ]);
            }
        }
        // Cut everything inside the support layout
        linear_extrude(INTERFACE_LAYERS*LAYER_HEIGHT)
                polygon([
                    [0, 0],
                    [width, 0],
                    [width, length],
                    [0, length],
                ]);
    }
}

// An insert that should enable sliding while holding 4 direction.
// Both are made to be printed without support.
module TopSlide(length) {
    linear_extrude(length) polygon([
        [-WALL_THICKNESS, 0],
        [-WALL_THICKNESS, 8],
        [1, 8],
        [5, 6],
        [7, 3],
        [7, 0],
        [6, 0],
        [2.5, 5],
        [0, 5],
        [0, 3.5],
        [2.5, 2],
        [2.5, 0],
    ]);
}

module TopSlideInsert(length) {
    A=[5.2+WALL_THICKNESS, -WALL_THICKNESS];
    B=[2.4, 4.8];
    // Angle computation for information
    // AB=B-A; // ref = [1,0]
    // echo("angle = ", 90-acos(AB.y/sqrt(AB.x*AB.x+AB.y*AB.y)));
    // -> 54.8 degree overhang (printable with minor defect)
    linear_extrude(length) polygon([
        A,
        B,
        [0.2, 4.8],
        [0.2, 3.7],
        [2.8, 2.2],
        [2.8, -WALL_THICKNESS],
        [A.x, -WALL_THICKNESS],
    ]);
}

// A custom support to make all support start from the ground and have no lateral contact with the model.
// The support looks like this (inclination is set to be 45 degree):
//          |<--->| width
//      |<->| distance
//           _____
//           |   /   ^
//           |  /    |
//           / /     |
//          / /      |
//         / /       |  height - LAYER_HEIGHT
//        / /        |
//       / /         |
//      / /          |
//     / /           |
//    / /            |
//   / /             |
//   ||              |
//   ||              |
//   ||              |
//  /__\     .       v
//  |<>|  ground_width
module GroundSupport(length, height=20, distance=10, width=2, ground_width=4, thickness=2) {
    Support() {
        union() {
            rotate([0, -90, -90]) linear_extrude(length) {
                polygon([
                    // Diagonal support
                    [height-SUPPORT_OFFSET-width+(-distance-ground_width/2+thickness/2), -distance-ground_width/2-thickness/2],
                    [height-SUPPORT_OFFSET, 0],
                    [height-SUPPORT_OFFSET, width],
                    [height-SUPPORT_OFFSET-width+(-distance-ground_width/2+thickness/2), -distance-ground_width/2+thickness/2],
                    // base
                    [ground_width/2-thickness/2, -distance-ground_width/2+thickness/2],
                    [0, -distance],
                    [0, -distance-ground_width],
                    [ground_width/2-thickness/2, -distance-ground_width/2-thickness/2],
                ]);
            }
            translate([0, 0, height-SUPPORT_OFFSET]) SupportTopLayers(length, width);
        }
    }
}


module AluminiumExtrusionSlider(length=10, offset=EXTRUSION_OFFSET) {
    if (ENDER3_FIXATION) {
        rotate([90, -90, 0]) linear_extrude(height = length)
            polygon([
                [-2.25, 0],
                [-2.25, 3+offset],
                [-4, 3+offset],
                [-4, 4+offset],
                [-2.25, 5.5+offset],
                [2.25, 5.5+offset],
                [4, 4+offset],
                [4, 3+offset],
                [2.25, 3+offset],
                [2.25, 0],
            ]);
    }
}

module SquareAirVentPattern(h=WALL_THICKNESS, w=18.6, l=17.6, m=5, n=5) {
    d=min(w/m,l/n)/1.5;
    for (i = [w/n:w/n:w-w/n])
        for (j = [l/m:l/m:l-l/m])
            translate([i, j, 0]) cylinder(d=d, h=h);
}

module CircleAirVentPattern(h=WALL_THICKNESS, d=50, m=4) {
    t=d/m;
    difference() {
        union() {
            cylinder(d=t, h=h);
            for (j = [3*t/2:t:d]) {
                difference() {
                    cylinder(d=j+t/2, h=h);
                    cylinder(d=j, h=h);
                }
            }
        }
        translate([t/2, -t/4, 0]) cube([(d-t)/2, t/2, h]);
        translate([-2*t, -t/4, 0]) cube([(d-t)/2, t/2, h]);
        translate([-t/4, t/2, 0]) cube([t/2, (d-t)/2, h]);
        translate([-t/4, -2*t, 0]) cube([t/2, (d-t)/2, h]);
    }
}

function sum(a, i=0) = i < len(a) ? a[i] + sum(a, i+1) : 0;

function cumulate(a, i=1) =
    i < len(a) ? cumulate([
            for (j = [0:len(a)-1]) j == i ? a[i] + a[i-1] : a[j]
        ], i+1) : a;

function rev(arr) = [for (j = [len(arr)-1:-1:0]) arr[j]];

module CableBracket(h=30, w=20, depth=3) {
    angles = [30, 45, 60, 75];
    cosines = [for (i = angles) cos(i)];
    sines = [for (i = angles) sin(i)];
    l = w / sum(sines);
    t = depth;
    wpos = concat([0, 0], cumulate(l*sines));
    dw = concat([t, t], t*cosines);
    hpos = concat(concat([0], [for(e = rev(cumulate(rev(l*cosines)))) h - e]), [h]);
    dh = concat([0, -t*sines[0]], -t*sines);
    pos = [for (p=[0:len(wpos)-1]) [hpos[p], wpos[p]]];
    dpos = [for (p=[0:len(dw)-1]) [dh[p], dw[p]]];
    pos2 = pos + dpos;


    rotate([0, -90, -90]) union() {
        linear_extrude(depth) {
            polygon(concat(pos, rev(pos2)));
        }
        // Fillet
        translate([0, t, 0]) difference() {
            cube([t, t, t]);
            translate([t, t, 0]) cylinder(d=2*t, h=t);
        }
    }
}

// A bottom plate with fillet on 3 sides.
module FilletedBottom(w, l, h) {
    hull() {
        translate([0,0,h/2]) cube([w, l, h/2]);
        translate([h/2, l-h/2, 0]) cube([w-h, h/2, h]);
        translate([h/2, h/2, h/2]) sphere(h/2);
        translate([w-h/2, h/2, h/2]) sphere(h/2);
        translate([h/2,l,h/2]) rotate([90, 0, 0]) cylinder(h=h, d=h);
        translate([w-h/2,l,h/2]) rotate([90, 0, 0]) cylinder(h=h, d=h);
    }
}

module InsertTower(width = 8,
                   height = 12,
                   depth = 3,
                   insert_depth = 0) {
    translate([0, 0, width]) rotate([0, 90, -90])
        union() {
            translate([-height, 0,0]) cube([height,width-0.25,depth]);
            translate([-height, width-0.25, 0]) rotate([90, 0, 0]) linear_extrude(width-0.5) polygon([
                [0, 0],
                [0, depth+insert_depth],
                [width, depth+insert_depth],
                [width+10, depth],
                [width+10, 0],
            ]);
        }
}

module TopLevelSupportWithM3Insert(width = 8,
                                   height = 12,
                                   depth = 3,
                                   insert_depth = 3) {
    difference() {
        InsertTower(width, height, depth, insert_depth);
        // Insert for the screw head.
        translate([0, 0, width]) rotate([0, 90, -90]) translate([-height+width/2, width/2, 0]) {
            cylinder(d=2*screw_hole_diameter(3), h=3.5);
            cylinder(d=screw_hole_diameter(3), h=insert_depth+depth);
        }
    }
}

module UpperLevelRail(h, in=false) {
    clearance = in ? 0.15 : 0;
    linear_extrude(h) polygon([
        [0,0],
        [0,4-clearance],
        [3-2*clearance,2.25-clearance],
        [3-2*clearance,1.75+clearance],
        [1.5-2*clearance,1+clearance],
        [1.5-2*clearance,0]
    ]);
}

module UpperLevel() {
    offset = 5;
    length = BOX_LENGTH-FRONT_LENGTH-offset;
    translate([0, BOX_LENGTH-length, LEVEL_HEIGHT])
        difference() {
            union() {
                difference() {
                    MainboardFeet([0, -BOX_LENGTH+length, -WALL_THICKNESS]) {
                        // Bottom
                        translate([0, 0, -WALL_THICKNESS])
                            linear_extrude(WALL_THICKNESS)
                                polygon(BLOWER_COOLING ? [
                                    [REVERSED ? BOX_WIDTH - WALL_THICKNESS : WALL_THICKNESS, -offset],
                                    [REVERSED ? BOX_WIDTH - 10 - offset : 10 + offset, -offset],
                                    [REVERSED ? 31 : BOX_WIDTH-31, -55],
                                    [REVERSED ? WALL_THICKNESS + 0.5 : BOX_WIDTH-WALL_THICKNESS-0.5, -55],
                                    [REVERSED ? WALL_THICKNESS + 0.5 : BOX_WIDTH-WALL_THICKNESS-0.5, -offset],
                                    [REVERSED ? WALL_THICKNESS : BOX_WIDTH-WALL_THICKNESS, -offset],
                                    [REVERSED ? WALL_THICKNESS : BOX_WIDTH-WALL_THICKNESS, length],
                                    [REVERSED ? BOX_WIDTH-WALL_THICKNESS : WALL_THICKNESS, length],
                                ] : [
                                    [WALL_THICKNESS, 0],
                                    [BOX_WIDTH-WALL_THICKNESS, 0],
                                    [BOX_WIDTH-WALL_THICKNESS, length],
                                    [WALL_THICKNESS, length],
                                ]);
                        translate([WALL_THICKNESS, -offset, 0]) cube([BOX_WIDTH-2*WALL_THICKNESS, BOX_LENGTH-FRONT_LENGTH-WALL_THICKNESS, WALL_THICKNESS]);
                    }

                    // cut out extra  piece
                    translate([0, length-1, -WALL_THICKNESS]) cube([BOX_WIDTH, BOX_LENGTH, BOX_HEIGHT]);
                }
                // Left
                translate([0, -offset, -WALL_THICKNESS]) hull() {
                    translate([WALL_THICKNESS/2, 0, 0]) cube([WALL_THICKNESS/2, length+offset, BOX_HEIGHT-LEVEL_HEIGHT+WALL_THICKNESS]);
                    cube([WALL_THICKNESS/2, length+offset-WALL_THICKNESS/2, BOX_HEIGHT-LEVEL_HEIGHT+WALL_THICKNESS]);
                    translate([WALL_THICKNESS/2, length+offset-WALL_THICKNESS/2, 0]) cylinder(h=BOX_HEIGHT-LEVEL_HEIGHT+WALL_THICKNESS, d=WALL_THICKNESS);
                }
                // Right
                translate([BOX_WIDTH-WALL_THICKNESS, -offset, -WALL_THICKNESS]) hull() {
                    cube([WALL_THICKNESS/2, length+offset, BOX_HEIGHT-LEVEL_HEIGHT+WALL_THICKNESS]);
                    translate([WALL_THICKNESS/2, 0, 0]) cube([WALL_THICKNESS/2, length+offset-WALL_THICKNESS/2, BOX_HEIGHT-LEVEL_HEIGHT+WALL_THICKNESS]);
                    translate([WALL_THICKNESS/2, length-WALL_THICKNESS/2, 0]) cylinder(h=BOX_HEIGHT-LEVEL_HEIGHT+WALL_THICKNESS, d=WALL_THICKNESS);
                }
                // Back
                translate([WALL_THICKNESS, length, -WALL_THICKNESS])
                    rotate([90, 0, 0])
                        linear_extrude(WALL_THICKNESS)
                            polygon([
                                [0, 0],
                                [BOX_WIDTH-2*WALL_THICKNESS, 0],
                                [BOX_WIDTH-2*WALL_THICKNESS, BOX_HEIGHT-LEVEL_HEIGHT],
                                [0, BOX_HEIGHT-LEVEL_HEIGHT]
                            ]);
                // Support for 5015 fan
                if (BLOWER_COOLING) {
                    if (REVERSED){
                        translate([69, -12.1, 0]) MFoot(3, h=14+WALL_THICKNESS);
                        translate([26.3, -49.7, 0]) MFoot(3, h=14+WALL_THICKNESS);
                        // Cooling: tunnel for the 5015 fan
                        translate([47.15, -30.9, 0]) difference() {
                            translate([0,0,-WALL_THICKNESS]) {
                                cylinder(d=40+2*WALL_THICKNESS, h=14+2*WALL_THICKNESS, $fn=50);
                                translate([-43.5, -12.5, 0]) cube([27.5,25,14+2*WALL_THICKNESS]);
                            }
                            translate([0,0,2.5]) minkowski() {
                                union() {
                                    cylinder(d=35, h=14+WALL_THICKNESS);
                                    translate([-50, -8, 0]) cube([40,16,10]);
                                }
                                sphere(d=5);
                            }
                        }
                    } else {
                        translate([60, -20, 0]) cylinder(d=10, h=14+WALL_THICKNESS);
                        translate([33.1, -12.1, 0]) MFoot(3, h=14+WALL_THICKNESS);
                        translate([75.8, -49.7, 0]) MFoot(3, h=14+WALL_THICKNESS);
                    }
                    // Insert for air tunnel for stepper motor cooling
                    translate([REVERSED ? 19 : 59.3,115.2,WALL_THICKNESS]) {
                        cube([22.6,12.8,13.5]);
                        translate([0,0,13.5]) {
                            cube([WALL_THICKNESS, 12.8, 17.6]);
                            translate([20.6, 0, 0])
                                cube([WALL_THICKNESS, 12.8, 17.6]);
                            translate([0, 0, 17.6])
                                cube([22.6, 12.8, WALL_THICKNESS]);
                        }
                    }
                } else {
                    // Support for the screw insert for the cover.
                    translate([REVERSED ? 19 : 80,115.2,0]) cube([1.9,12.8,31+WALL_THICKNESS]);
                    translate([REVERSED ? 19 : 59.3,115.2,33]) rotate([0,90,0]) linear_extrude(22.6) polygon([
                        [0,0],
                        [12.8, 12.8],
                        [0, 12.8]
                    ]);
                }
                // Cable management: attach for zipties next to the cable exit.
                translate([REVERSED ? 19 : 81.9,115.2,0]) {
                    mirror([REVERSED ? 1 : 0,0,0]) difference() {
                        hull() {
                            cube([5,6,30]);
                            translate([0,6,30]) rotate([90,0,0]) cylinder(d=10, h=6, $fn=100);
                        }
                        translate([-5,0,0]) cube([5,6,40]);
                        translate([1,0,10]) cube([2.5,6,20]);
                    }
                }
                // Cable management: bracket
                translate([REVERSED ? 15 : BOX_WIDTH-15, 12.5, WALL_THICKNESS]) {
                    // Along the mainboard
                    rotate([0,0, REVERSED ? 180 : 0]) CableBracket(h=35-WALL_THICKNESS, w=7, depth=2*WALL_THICKNESS);
                    translate([0, 68, 0]) rotate([0,0, REVERSED ? 180 : 0]) CableBracket(h=35-WALL_THICKNESS, w=7, depth=2*WALL_THICKNESS);
                    translate([0, 96, 0]) rotate([0,0, REVERSED ? 180 : 0]) CableBracket(h=35-WALL_THICKNESS, w=7, depth=2*WALL_THICKNESS);
                }
                // Frame assembly: screw for the cover over the air vent
                translate([REVERSED ? 30.3 : 70.6,121.6,33])
                    MFoot(3, h=BOX_HEIGHT-LEVEL_HEIGHT-WALL_THICKNESS-33) {
                        translate([-11.3, -6.4, 0]) cube([22.6,12.8, BOX_HEIGHT-LEVEL_HEIGHT-WALL_THICKNESS-33]);
                    }
                // Assembly: Slides for the cover.
                translate([WALL_THICKNESS+0.2,70-offset,BOX_HEIGHT-WALL_THICKNESS-LEVEL_HEIGHT])
                    rotate([0,90,-90]) TopSlideInsert(10);
                translate([BOX_WIDTH-WALL_THICKNESS-0.2,60-offset,BOX_HEIGHT-WALL_THICKNESS-LEVEL_HEIGHT])
                    rotate([0,90,90]) TopSlideInsert(10);
                // Assembly: support for the cover, containing also screw insert for the frame.
                translate([WALL_THICKNESS, -offset+7, -8])
                    TopLevelSupportWithM3Insert(depth=7, insert_depth=5, height=BOX_HEIGHT-LEVEL_HEIGHT);
                translate([BOX_WIDTH-WALL_THICKNESS, -offset+7, -8])
                    mirror([1,0,0]) TopLevelSupportWithM3Insert(depth=7, insert_depth=5, height=BOX_HEIGHT-LEVEL_HEIGHT);
            }
            // Air vent for the stepper motor cooling.
            if (BLOWER_COOLING)
                Orientate(direction=[0,1,0], position=[(REVERSED ? 19 : 59.3)+WALL_THICKNESS, length-WALL_THICKNESS, 13.5+WALL_THICKNESS], rotation=-90)
                    SquareAirVentPattern();
            // Cable management: cable out
            Orientate(direction=[0,1,0], position=[REVERSED ? 5 : BOX_WIDTH-5, length-WALL_THICKNESS, REVERSED ? 23.5 : 13.5], rotation=REVERSED ? 90 : -90) {
                intersection() {
                    hull() {
                        cylinder(d=20, h=WALL_THICKNESS);
                        translate([10, 0, 0]) cylinder(d=20, h=WALL_THICKNESS);
                        translate([0, 10, 0]) cylinder(d=20, h=WALL_THICKNESS);
                        translate([10, 10, 0]) cylinder(d=20, h=WALL_THICKNESS);
                    }
                    translate([-25,-45-WALL_THICKNESS,0]) cube([50, 50, WALL_THICKNESS]);
                }
            }

            // Main board ports
            if (CREALITY_MELZI_BOARD) {
                translate([0, 0, 4.5+WALL_THICKNESS]) {
                    // SD-card slot
                    translate([MAINBOARD_POSITION.x-MAINBOARD_SIZE.x/2+2, length-WALL_THICKNESS, 0])
                        cube([15.5, WALL_THICKNESS, 3]);
                    // USB port
                    translate([MAINBOARD_POSITION.x-MAINBOARD_SIZE.x/2+22, length-WALL_THICKNESS, 0])
                        cube([8.5, WALL_THICKNESS, 4.5]);
                }
            } else {
                translate([REVERSED ? BOX_WIDTH - WALL_THICKNESS : 0, MAINBOARD_POSITION[1]-BOX_LENGTH+length, 5.5+WALL_THICKNESS]) {
                    // SD-card slot
                    translate([0, REVERSED ? -12.8 : -2.8, 0]) cube([WALL_THICKNESS, 15.5, 3]);
                    // USB port
                    translate([0, REVERSED ? -30.8 : 18.2, 0]) cube([WALL_THICKNESS, 12.5, 11]);
                }
            }

            // Cooling for the MOSFET under the board (place for heat sink)
            if (!CREALITY_MELZI_BOARD) translate([20, 88, -WALL_THICKNESS]) {
                cube([38.5, 16, 2*WALL_THICKNESS]);
            }
            // Frame assembly part: 1 hole for screwing to the bottom
            translate([REVERSED ? BOX_WIDTH-6 : 6, 122, -WALL_THICKNESS]) cylinder(d=screw_hole_diameter(3), h=2*WALL_THICKNESS);
            // Frame assembly: rails for attaching to the lower part
            translate([0, length,-2]) rotate([90,0,0]) UpperLevelRail(length+offset);
            translate([BOX_WIDTH, length,-2]) mirror([1,0,0]) rotate([90,0,0]) UpperLevelRail(length+offset);
            // A little chamfer to make sliding this level easier.
            if (BLOWER_COOLING) {
                translate([REVERSED ? WALL_THICKNESS+0.5 : BOX_WIDTH-WALL_THICKNESS-0.5, REVERSED ? -BOX_LENGTH-offset : -offset, 0])
                    rotate([-90,0, REVERSED ? 0 : 180]) linear_extrude(BOX_LENGTH) polygon([[0,0],[0,1], [1,0]]);
            }
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

module ScreenBorder(length = BOX_LENGTH) {
    translate([WALL_THICKNESS, 0, WALL_THICKNESS])
        rotate([0,-90,0])
            linear_extrude(WALL_THICKNESS)
                polygon([[0,0],
                        [0, length],
                        [BOX_HEIGHT-WALL_THICKNESS, length],
                        [BOX_HEIGHT-WALL_THICKNESS, LCD_LENGTH],
                        [LCD_SMALL_HEIGHT-WALL_THICKNESS, 0]]);
}

module Endcap(height=10, h=2, clearance=0, offset=EXTRUSION_OFFSET) {
    d=2;
    union() {
        cube([offset+40+WALL_THICKNESS,WALL_THICKNESS*2,40+WALL_THICKNESS]);
        rotate([-90, 0, 0]) translate([offset+21,-21,-height+2*h]) {
            length = 17.6-clearance;
            width = 5.6-clearance;
            small_width = 3-clearance;
            small_length = 1.5-clearance;
            medium_length = 6-clearance;
            five_points = [
                [-width, width],
                [-width, length-medium_length],
                [-small_width, length-small_length],
                [-small_width, length],
                [small_width, length],
                [small_width, length-small_length],
                [width, length-medium_length],
                [width, width],
            ];
            rotation = [[0, 1], [-1, 0]];
            poly =concat(
                        five_points,
                        five_points*rotation,
                        five_points*rotation*rotation,
                        five_points*rotation*rotation*rotation
                    );
            linear_extrude(height)
                polygon(poly);
        }
    }
}

module 40ExtrusionEndcap(clearance=0.4, offset=EXTRUSION_OFFSET) {
    if (ENDER3_FIXATION) {
        Endcap(clearance=clearance, offset=offset);
        // Endcap support
        translate([offset+38.6-clearance, -6, 0])
            rotate([0, 0, 90]) GroundSupport(34.1+clearance, height=3.4+clearance, distance=-3, width=2*WALL_THICKNESS);
        translate([offset+32.5, -6, 0])
            rotate([0, 0, 90]) GroundSupport(5.4+clearance, height=15.4+clearance, distance=-3, width=2*WALL_THICKNESS);
        translate([offset+14.9+clearance, -6, 0])
            rotate([0, 0, 90]) GroundSupport(5.4+clearance, height=15.4+clearance, distance=-3, width=2*WALL_THICKNESS);
        translate([offset+38.6-clearance, -6, 0])
            rotate([0, 0, 90]) GroundSupport(1.1-clearance, height=18+clearance, distance=-3, width=2*WALL_THICKNESS);
        translate([offset+4.5, -6, 0])
            rotate([0, 0, 90]) GroundSupport(1.1-clearance, height=18+clearance, distance=-3, width=2*WALL_THICKNESS);
    }
}

module RelayOrUpsFeet(foot_x) {
    if (USE_MINI_UPS) {
        foot_x = REVERSED ? 55.95: 87.25;
        MiniUps24VFeet(pos=[foot_x, 46, WALL_THICKNESS], angle=-90)
            children();
    } else {
        RelaySwitchFeet(pos=[foot_x, 69.5, WALL_THICKNESS], angle=-90)
            children();
    }
}
module ScreenBoxFront(length=FRONT_LENGTH) {
    difference() {
        foot_x = REVERSED ? 50.95: 82.25;
        // Relay switch feet (x3)
        RelaySwitchFeet(pos=[foot_x, 124.5, WALL_THICKNESS], angle=-90)
        RelaySwitchFeet(pos=[foot_x, 97.5, WALL_THICKNESS], angle=-90)
        RelayOrUpsFeet(foot_x) {
            // Left
            ScreenBorder(length);
            // Right
            translate([BOX_WIDTH-WALL_THICKNESS, 0, 0]) ScreenBorder(length);
            // Bottom
            FilletedBottom(BOX_WIDTH, length, WALL_THICKNESS);
            // Front with screen screw insert.
            MFoot(5, direction=[0, 1, 0], pos=[10, 0, 11], h=10)
                MFoot(5, direction=[0, 1, 0], pos=[30, 0, 31], h=10)
                    translate([0,0,WALL_THICKNESS]) union() {
                        cube([BOX_WIDTH, WALL_THICKNESS, LCD_SMALL_HEIGHT-WALL_THICKNESS]);
                        cube([43, 10, 43-WALL_THICKNESS]);
                    }
            translate([REVERSED ? 0 : BOX_WIDTH, WALL_THICKNESS, 0]) mirror([REVERSED ? 1 : 0,0,0]) mirror([0,1,0]) 40ExtrusionEndcap();
            if (AIY_KIT) {
                // Housing frame for Speaker
                translate([REVERSED ? BOX_WIDTH : 0, 0, 0]) mirror([REVERSED ? 1 : 0, 0, 0]) {
                    translate([0, length-WALL_THICKNESS, WALL_THICKNESS]) cube([32, WALL_THICKNESS, 50-WALL_THICKNESS]);
                    translate([0, 77, WALL_THICKNESS]) {
                        cube([32, WALL_THICKNESS, 50-WALL_THICKNESS]);
                        translate([32, 0, 0]) cube([WALL_THICKNESS, length-77, 50-WALL_THICKNESS]);
                        translate([20, 0, 0]) difference() {
                            cube([WALL_THICKNESS, length-77, 50-WALL_THICKNESS]);
                            translate([0, 22, 40-WALL_THICKNESS]) {
                                cube([WALL_THICKNESS, 41, 20]);
                                translate([0, 20.5, 0]) rotate([0, 90, 0]) cylinder(d=41, h=WALL_THICKNESS);
                            }
                        }
                    }
                }
            }
            // Assembly: frame clips
            translate([0, length+4, WALL_THICKNESS]) {
                translate([BOX_WIDTH/3-2, 0, 0]) mirror([0, 1, 0]) InsertWithFillet();
                translate([2*BOX_WIDTH/3-2, 0, 0]) mirror([0, 1, 0]) InsertWithFillet();
            }
            // Assembly: frame screws
            translate([BOX_WIDTH-10, 142, BOX_HEIGHT]) ScrewInsertForFrameAssembly();
            translate([10, 142, BOX_HEIGHT]) mirror([1,0,0]) ScrewInsertForFrameAssembly();

            if (BLOWER_COOLING) {
                // Assembly: Support for upper level
                translate([REVERSED ? WALL_THICKNESS : BOX_WIDTH-WALL_THICKNESS, length-WALL_THICKNESS-(REVERSED ? 55 : 0), LEVEL_HEIGHT-WALL_THICKNESS]) {
                    rotate([0,0,REVERSED ? 0 : 180]) LevelSupport(55);
                    // Stop for the upper level
                    translate([REVERSED ? 0 : -10, REVERSED ? 0 : -55, 0]) cube([10,5,10]);
                }
                // Assembly: slider for upper level (one side only)
                translate([REVERSED ? WALL_THICKNESS : BOX_WIDTH-WALL_THICKNESS, 120, LEVEL_HEIGHT])
                    mirror([REVERSED ? 0 : 1,0,0]) UpperLevelBlocker(depth=7, height=18);
            }
            if (ENDER3_FIXATION) {
                // Assembly: Slider for 40x40 aluminium extrusion.
                // Note this part needs support.
                translate([REVERSED ? 0 : BOX_WIDTH, 132, 30]) {
                    mirror([REVERSED ? 0 : 1, 0, 0]) AluminiumExtrusionSlider(120);
                }
                translate([REVERSED ? 0 : BOX_WIDTH, 132, 10]) {
                    mirror([REVERSED ? 0 : 1, 0, 0]) AluminiumExtrusionSlider(120);
                }
            }
            // Assembly: Cantilever
            translate([BOX_WIDTH-WALL_THICKNESS, FRONT_LENGTH, WALL_THICKNESS]) {
                translate([0,0,16]) mirror([1,0,0]) Cantilever(10);
                if (!AIY_KIT || !REVERSED) {
                    translate([-3,-5,0]) cube([3, 5, 26]);
                }
                translate([0,0,0.5]) mirror([1,0,0]) Cantilever(4);
            }
            translate([WALL_THICKNESS, FRONT_LENGTH, WALL_THICKNESS]) {
                translate([0,0,16]) Cantilever(10);
                if (!AIY_KIT || REVERSED) {
                    translate([0,-5,0]) cube([3, 5, 26]);
                }
                translate([0,0,0.5]) Cantilever(4);
            }
            // Assembly: Slides for the cover.
            translate([WALL_THICKNESS+0.2,LCD_LENGTH+20,BOX_HEIGHT-WALL_THICKNESS])
                rotate([0,90,-90]) TopSlideInsert(10);
            translate([BOX_WIDTH-WALL_THICKNESS-0.2,LCD_LENGTH+10,BOX_HEIGHT-WALL_THICKNESS])
                rotate([0,90,90]) TopSlideInsert(10);
            // Cable management: some brackets
            translate([REVERSED ? BOX_WIDTH - WALL_THICKNESS - 40 : 40, 45, WALL_THICKNESS])
                rotate([0,0,-90]) CableBracket(h=30, w=10, depth=2*WALL_THICKNESS);
            translate([REVERSED ? BOX_WIDTH - WALL_THICKNESS - 70 : 70, 45, WALL_THICKNESS])
                rotate([0,0,-90]) CableBracket(h=30, w=10, depth=2*WALL_THICKNESS);

            // Supports
            if(ENDER3_FIXATION) {
                translate([EXTRUSION_OFFSET + (REVERSED ? -5 : BOX_WIDTH+5), (REVERSED ? 0 : 120)+10+WALL_THICKNESS, 0]) {
                    // Extrusion slides.
                    rotate([0, 0, REVERSED ? 0 : 180]) GroundSupport(120, height=10-4, distance=1, width=2);
                    rotate([0, 0, REVERSED ? 0 : 180]) GroundSupport(120, height=30-4, distance=1, width=2);
                }
            }
            // Snapfit supports
            translate([2, length+1, 0])
                GroundSupport(5, height=18, distance=1, width=3);
            translate([BOX_WIDTH-2, length+6, 0])
                rotate([0, 0, 180]) GroundSupport(5, height=18, distance=1, width=3);
            translate([0, length+1, 0]) {
                Support() {
                    cube([BOX_WIDTH, 5, WALL_THICKNESS-SUPPORT_OFFSET]);
                    translate([BOX_WIDTH/3-1,0,SUPPORT_OFFSET]) SupportTopLayers(3, 6);
                    translate([2*BOX_WIDTH/3-1,0,SUPPORT_OFFSET]) SupportTopLayers(3, 6);
                    translate([2, 0, 0]) {
                        cube([3, 5, WALL_THICKNESS+0.5-SUPPORT_OFFSET]);
                        translate([0,0,WALL_THICKNESS+0.5-SUPPORT_OFFSET]) SupportTopLayers(5, 3);
                    }
                    translate([BOX_WIDTH-5.5, 0, 0]) {
                        cube([3, 5, WALL_THICKNESS+0.5-SUPPORT_OFFSET]);
                        translate([0,0,WALL_THICKNESS+0.5-SUPPORT_OFFSET]) SupportTopLayers(5, 3);
                    }
                }
            }

        }
        if (BLOWER_COOLING) {
            if (REVERSED) {
                // Air intake for the stepper motor cooling.
                Orientate(direction=[1,0,0], position=[0, length-13.5, LEVEL_HEIGHT + 16.5], rotation=-90)
                    SquareAirVentPattern(l=18, w=25);
            }
            // Clearance for the upper level.
            translate([REVERSED ? WALL_THICKNESS-0.4 : BOX_WIDTH-WALL_THICKNESS, length-55, LEVEL_HEIGHT-WALL_THICKNESS])
                cube([0.4, 55, WALL_THICKNESS]);
        }
        if (AIY_KIT) {
            if (BLOWER_COOLING) translate([0.5, BOX_LENGTH-130, LEVEL_HEIGHT-WALL_THICKNESS]) {
                linear_extrude(30)
                    polygon([
                        [REVERSED ? BOX_WIDTH-8 : 8, 0],
                        [REVERSED ? 33 : BOX_WIDTH-33, -55],
                        [REVERSED ? 33 : BOX_WIDTH-33, 0],
                    ]);
                translate([0,0,-20]) linear_extrude(50)
                    polygon([
                        [REVERSED ? BOX_WIDTH - 15 : 14, 0],
                        [REVERSED ? 33 : BOX_WIDTH-33, -50],
                        [REVERSED ? 33 : BOX_WIDTH-33, 0],
                    ]);
            }
            // Speaker holes
            translate([REVERSED ? BOX_WIDTH-WALL_THICKNESS : 0, 118, 40]) rotate([0,90,0]) union() {
                cylinder(d=15, h=WALL_THICKNESS);
                translate([20, 0, 0]) cylinder(d=15, h=WALL_THICKNESS);
                translate([-20, 0, 0]) cylinder(d=15, h=WALL_THICKNESS);
                translate([10, -20, 0]) cylinder(d=15, h=WALL_THICKNESS);
                translate([-10, -20, 0]) cylinder(d=15, h=WALL_THICKNESS);
                translate([10, 20, 0]) cylinder(d=15, h=WALL_THICKNESS);
                translate([-10, 20, 0]) cylinder(d=15, h=WALL_THICKNESS);
            }
        }
    }
}

module LevelSupport(length) {
    rotate([-90,0,0]) linear_extrude(length) polygon([
        [0, 0],
        [0, 15],
        [10, 4],
        [10, 0]
    ]);
}

module UpperLevelBlocker(width = 8,
                        height = 12,
                        depth = 3) {
    translate([0, 0, width]) rotate([0, 90, -90])
        union() {
            intersection() {
                cylinder(d=2*width-0.5, h=depth);
                cube([2*width-0.5, 2*width-0.5, depth]);
            }
            translate([-height, 0,0]) cube([height,width-0.25,depth]);
            translate([-height, width-0.25, 0]) rotate([90, 0, 0]) linear_extrude(width-0.5) polygon([
                [0, 0],
                [0, depth],
                [width, depth],
                [width+10, depth],
                [width+10, 0],
            ]);
        }
}

module ScrewInsertForFrameAssembly(width = 8, height = 12) {
    h = 13;
    p = 16;
    angle = 40;
    difference() {
        translate([-0.2, 0, 0]) union() {
            rotate([0, 90, 0])  {
                linear_extrude(width + 0.2) polygon([
                    [0, 0],
                    [h, 0],
                    [h, p],
                    [width, height],
                    [0, height],
                ]);
                translate([0, 0,-WALL_THICKNESS]) cube([h, p, WALL_THICKNESS]);
            }
        }
        //  Chamfer to avoid support.
        translate([-WALL_THICKNESS, p, -h]) rotate([90, 0, 0]) linear_extrude(p) {
            polygon([
                [-0.4, 0],
                [-0.4, width * tan(angle)],
                [width+WALL_THICKNESS, 0],
            ]);
        }
        translate([width/2, p, -height+width]) rotate([90, 0, 0]) cylinder(d=insert_diameter(3), h=p);
        translate([-WALL_THICKNESS-1, 6.5, -h]) rotate([-45, 0, 0]) cube([WALL_THICKNESS+1, 20, 20]);
    }
}

module InsertWithFillet() {
    // Note: needs support (on the build plate).
    intersection() {
        union() {
            cube([8, 8, WALL_THICKNESS]);
            translate([0, 0, WALL_THICKNESS/2]) rotate([0, 90, 0]) cylinder(d=WALL_THICKNESS, h=8);
        }
        union() {
            translate([0, 4, 0]) cube([8, 8, WALL_THICKNESS]);
            translate([1, -2, 0]) cube([6, 12, WALL_THICKNESS]);
            translate([1, -2, WALL_THICKNESS/2]) rotate([-90, 0, 0]) cylinder(d=WALL_THICKNESS, h=12);
            translate([7, -2, WALL_THICKNESS/2]) rotate([-90, 0, 0]) cylinder(d=WALL_THICKNESS, h=12);
        }
    }
}

module ScreenBoxBack(front_length=FRONT_LENGTH) {
    // Buck converter feet (x2)
    BuckConverterFeet(pos=[65, 232, WALL_THICKNESS], angle=-90)
    BuckConverterFeet(pos=[65, 256, WALL_THICKNESS], angle=-90)
    // Raspberry pi feet
    RaspberryPiFeet(pos=RASPBERRY_PI_POSITION + [REVERSED ? -30.5 : -10.5, 28, WALL_THICKNESS], angle=-90) {
        difference() {
            translate([0, front_length, 0]) {
                // Left
                translate([0,0,WALL_THICKNESS]) hull() {
                    translate([WALL_THICKNESS/2, 0, 0]) cube([WALL_THICKNESS/2, BOX_LENGTH-front_length, LEVEL_HEIGHT-2*WALL_THICKNESS]);
                    cube([WALL_THICKNESS/2, BOX_LENGTH-front_length-WALL_THICKNESS/2, LEVEL_HEIGHT-2*WALL_THICKNESS]);
                    translate([WALL_THICKNESS/2, BOX_LENGTH-front_length-WALL_THICKNESS/2, 0]) cylinder(h=LEVEL_HEIGHT-2*WALL_THICKNESS, d=WALL_THICKNESS);
                }
                // Right
                translate([BOX_WIDTH-WALL_THICKNESS, 0, WALL_THICKNESS]) hull() {
                    cube([WALL_THICKNESS/2, BOX_LENGTH-front_length, LEVEL_HEIGHT-2*WALL_THICKNESS]);
                    translate([WALL_THICKNESS/2, 0, 0]) cube([WALL_THICKNESS/2, BOX_LENGTH-front_length-WALL_THICKNESS/2, LEVEL_HEIGHT-2*WALL_THICKNESS]);
                    translate([WALL_THICKNESS/2, BOX_LENGTH-front_length-WALL_THICKNESS/2, 0]) cylinder(h=LEVEL_HEIGHT-2*WALL_THICKNESS, d=WALL_THICKNESS);
                }
                // Bottom
                translate([BOX_WIDTH, BOX_LENGTH-front_length, 0]) rotate([0,0,180]) FilletedBottom(BOX_WIDTH, BOX_LENGTH-front_length, WALL_THICKNESS);
                // Assembly: Cantilever
                translate([WALL_THICKNESS, 0, 0]) CantileverSupport(31);
                translate([BOX_WIDTH-WALL_THICKNESS, 0, 0])
                    mirror([1,0,0]) CantileverSupport(31);
            }
            // Raspberry Pi Ports
            translate([REVERSED ? BOX_WIDTH - 10 : 0, RASPBERRY_PI_POSITION[1], 6.5]) {
                // Ethernet
                translate([0, REVERSED ? -27 : 9, 0])
                    cube([10, 18, 15]);
                // USB
                translate([0, REVERSED ? -9 : -27, 0])
                    cube([10, 37, 17]);
            }
            sd_card_y = REVERSED ? -12.8 : -2.8;
            // Main board ports
            translate([REVERSED ? BOX_WIDTH - WALL_THICKNESS : 0, MAINBOARD_POSITION[1], LEVEL_HEIGHT+5.5]) {
                // SD-card slot
                translate([0, sd_card_y, 0]) cube([WALL_THICKNESS, 15.5, 3]);
                // USB port
                translate([0, REVERSED ? -30.8 : 18.2, 0]) cube([WALL_THICKNESS, 12.5, 11]);
            }
        }
        // Assembly: Support for upper level
        translate([REVERSED ? BOX_WIDTH-WALL_THICKNESS : WALL_THICKNESS, REVERSED ? BOX_LENGTH : front_length, LEVEL_HEIGHT-WALL_THICKNESS])
            MFoot(3, thickness=0, pos=[REVERSED ? -4 : 4, REVERSED ? -8 : BOX_LENGTH-front_length-8,-screw_insert_depth(3)])
                rotate([0,0, REVERSED ? 180 : 0]) LevelSupport(BOX_LENGTH-front_length);
        translate([REVERSED ? WALL_THICKNESS : BOX_WIDTH-WALL_THICKNESS, REVERSED ? front_length : BOX_LENGTH, LEVEL_HEIGHT-WALL_THICKNESS])
            rotate([0,0,REVERSED ? 0 : 180]) LevelSupport(BOX_LENGTH-front_length);

        // Assembly: Slider for 40x40 aluminium extrusion.
        // Note this part needs support.
        translate([REVERSED ? 0 : BOX_WIDTH, BOX_LENGTH-WALL_THICKNESS-10, 30]) {
            mirror([REVERSED ? 0 : 1, 0, 0]) AluminiumExtrusionSlider(120);
        }
        translate([REVERSED ? 0 : BOX_WIDTH, BOX_LENGTH-WALL_THICKNESS-10, 10]) {
            mirror([REVERSED ? 0 : 1, 0, 0]) AluminiumExtrusionSlider(120);
        }

        // Frame assembly: slider for attaching to the upper part
        translate([0, BOX_LENGTH, LEVEL_HEIGHT-2]) rotate([90,0,0]) UpperLevelRail(BOX_LENGTH-front_length, true);
        translate([BOX_WIDTH, BOX_LENGTH, LEVEL_HEIGHT-2]) mirror([1,0,0]) rotate([90,0,0]) UpperLevelRail(BOX_LENGTH-front_length, true);

        // Assembly: frame clips
        translate([BOX_WIDTH/2-4, front_length-4, WALL_THICKNESS]) InsertWithFillet();
        // Back
        translate([0, BOX_LENGTH-WALL_THICKNESS, 0]) {
            // Frame for the fan
            translate([REVERSED ? 41.8 : 21.8, -10, 0]) cube([WALL_THICKNESS, 10, 40]);
            translate([REVERSED ? 84.2 : 64.2, -10, 0]) cube([WALL_THICKNESS, 10, 40]);
            // Mounting hole for the fan
            Foot(pos=[REVERSED ? 48 : 28, WALL_THICKNESS, 6.5], d1=5.4, d2=screwin_diameter(3), h=3+WALL_THICKNESS, direction=[0,-1,0])
            Foot(pos=[REVERSED ? 80 : 60, WALL_THICKNESS, 38.5], d1=5.4, d2=screwin_diameter(3), h=3+WALL_THICKNESS, direction=[0,-1,0])
                difference() {
                    // Back panel
                    translate([REVERSED ? 0 : WALL_THICKNESS,0,WALL_THICKNESS]) cube([BOX_WIDTH-WALL_THICKNESS, WALL_THICKNESS, LEVEL_HEIGHT-2*WALL_THICKNESS]);
                    translate([(REVERSED ? 62.2 : 42.2)+WALL_THICKNESS, 0, 20.7+WALL_THICKNESS]) rotate([-90,0,0]) CircleAirVentPattern(d=39,h=WALL_THICKNESS);
                    // Cable management: hole for 24V line in
                    translate([REVERSED ? 0 : BOX_WIDTH-5, WALL_THICKNESS, 0]) rotate([90, 0, 0]) hull() {
                        cylinder(d=10, h=WALL_THICKNESS);
                        translate([0, 5, 0]) cylinder(d=10, h=WALL_THICKNESS);
                        translate([5, 5, 0]) cylinder(d=10, h=WALL_THICKNESS);
                        translate([5, 0, 0]) cylinder(d=10, h=WALL_THICKNESS);
                    }
                }
            // 40x40 Extrusion side
            translate([REVERSED ? 0 : BOX_WIDTH, 0, 0]) mirror([REVERSED ? 1 : 0,0,0]) 40ExtrusionEndcap();
        }
        // Supports
        // RPi ports
        translate([REVERSED ? BOX_WIDTH : 0, RASPBERRY_PI_POSITION[1]+(REVERSED ? -9 : 10), 0]) rotate([0,0,REVERSED ? 180 : 0]) GroundSupport(10, height=6.5+15, distance=2, width=WALL_THICKNESS, ground_width=8);
        if (ENDER3_FIXATION) {
            translate([EXTRUSION_OFFSET + (REVERSED ? -5 : BOX_WIDTH+5), BOX_LENGTH-WALL_THICKNESS-(REVERSED ? 130 : 10), 0]) {
                // Extrusion slides.
                rotate([0, 0, REVERSED ? 0 : 180]) GroundSupport(120, height=10-4, distance=1, width=2);
                rotate([0, 0, REVERSED ? 0 : 180]) GroundSupport(120, height=30-4, distance=1, width=2);
            }
        }
        // Snapfit support
        translate([BOX_WIDTH/2-4, front_length-4.5, 0])
            Support() {
                cube([8, 3.5, WALL_THICKNESS-SUPPORT_OFFSET]);
                translate([0,0,WALL_THICKNESS-SUPPORT_OFFSET]) SupportTopLayers(3.5, 8);
            }
    }
}

module Ender3Logo() {
    // Ender 3 logo.
    translate([62, BLOWER_COOLING ? 90 : 25, 0.5])
        scale([BLOWER_COOLING ? 1 : 0.9, BLOWER_COOLING ? 1 : 0.9, 1]) Ender3Relief();
}

module PCBSnapFit(h=3.5, h2=1, d=2, d2=3.5) {
    difference() {
        union() {
            cylinder(d=d, h=h);
            cylinder(d1=d, d2=d2, h=h2);
        }
        translate([-d, -d/6, 0]) cube([2*d, d/3, h]);
    }
}

module ScreenBoxTopFrame() {
    translate([0, BOX_LENGTH-LCD_LENGTH, 2*WALL_THICKNESS]) mirror([0,1,0]) mirror([0,0,1]) FilletedBottom(BOX_WIDTH, BOX_LENGTH-LCD_LENGTH-2, WALL_THICKNESS);
    translate([12.5, 2, 0]) cube([BOX_WIDTH-25, BOX_LENGTH-LCD_LENGTH-2, WALL_THICKNESS]);
    translate([12.5, -1, 0]) {
        rotate([0,90,0]) intersection() {
            translate([1,3,0]) cylinder(d=6, h=BOX_WIDTH-25);
            translate([-WALL_THICKNESS, 0, 0]) cube([WALL_THICKNESS, 3, BOX_WIDTH-25]);
        }
    }
    translate([WALL_THICKNESS+0.25, FRONT_LENGTH-LCD_LENGTH+30, 0]) cube([BOX_WIDTH-2*WALL_THICKNESS-0.5, BOX_LENGTH-FRONT_LENGTH-30, WALL_THICKNESS]);
}

module ScreenBoxTop(logo=0) {
    translate([0, LCD_LENGTH, BOX_HEIGHT-WALL_THICKNESS])
        if (logo) {
            color(LOGO_COLOR) Ender3Logo();
        } else {
            union() {
                difference() {
                    union() {
                        // Frame
                        if (BLOWER_COOLING) {
                            ScreenBoxTopFrame();
                        } else {
                            // Mounting hole for the cooling fans when using double 4010.
                            Foot(pos=[BOX_WIDTH/2-16,6+MAINBOARD_POSITION.y-LCD_LENGTH-(CREALITY_MELZI_BOARD ? 10 : 0),0], d1=5.4, d2=select_insert(3)[3], h=3+WALL_THICKNESS, direction=[0,0,-1])
                            Foot(pos=[BOX_WIDTH/2+16,38+MAINBOARD_POSITION.y-LCD_LENGTH-(CREALITY_MELZI_BOARD ? 10 : 0),0], d1=5.4, d2=select_insert(3)[3], h=3+WALL_THICKNESS, direction=[0,0,-1])
                            Foot(pos=[BOX_WIDTH/2-16,-38+MAINBOARD_POSITION.y-LCD_LENGTH-(CREALITY_MELZI_BOARD ? 10 : 0),0], d1=5.4, d2=select_insert(3)[3], h=3+WALL_THICKNESS, direction=[0,0,-1])
                            Foot(pos=[BOX_WIDTH/2+16,-6+MAINBOARD_POSITION.y-LCD_LENGTH-(CREALITY_MELZI_BOARD ? 10 : 0),0], d1=5.4, d2=select_insert(3)[3], h=3+WALL_THICKNESS, direction=[0,0,-1])
                            ScreenBoxTopFrame();
                        }
                        if (AIY_KIT) {
                            // AIY mic snap fit
                            translate([17, (BLOWER_COOLING ? 172.6 : 117.6)-LCD_LENGTH,-3.5]) {
                                translate([69.5, -5.1, 0]) PCBSnapFit();
                                translate([69.5, 5.1, 0]) PCBSnapFit();
                                translate([0, -5.1, 0]) PCBSnapFit();
                                translate([0, 5.1, 0]) PCBSnapFit();
                            }
                        }
                        if (BLOWER_COOLING && !REVERSED) {
                            // Cooling: tunnel for the 5015 fan
                            translate([55, 30, -BOX_HEIGHT+LEVEL_HEIGHT+WALL_THICKNESS+33]) difference() {
                                difference() {
                                    cylinder(d=40+2*WALL_THICKNESS, h=BOX_HEIGHT-LEVEL_HEIGHT-WALL_THICKNESS-33);
                                    cube([25,25,2]);
                                }
                                cylinder(d=40, h=18);
                            }
                        }
                        // Slides to snap to the box.
                        translate([WALL_THICKNESS+0.25,20,0]) rotate([0,90,-90]) TopSlide(10);
                        translate([BOX_WIDTH-(WALL_THICKNESS+0.25),10,0]) rotate([0,90,90]) TopSlide(10);
                        translate([WALL_THICKNESS+0.25,FRONT_LENGTH-30,0]) rotate([0,90,-90]) TopSlide(10);
                        translate([BOX_WIDTH-(WALL_THICKNESS+0.25),FRONT_LENGTH-40,0]) rotate([0,90,90]) TopSlide(10);
                    }
                    if (AIY_KIT) {
                        // AIY mic holes
                        translate([17, (BLOWER_COOLING ? 172.7 : 117.7)-LCD_LENGTH,0]) {
                            cylinder(d=3, h=2*WALL_THICKNESS);
                            translate([69.5, 0, 0]) cylinder(d=3, h=2*WALL_THICKNESS);
                            translate([24.75, -2, 0]) cube([20, 4, WALL_THICKNESS]);
                        }
                    }
                    if (BLOWER_COOLING) {
                        // Cooling: exhaust for the 5015 fan
                        if (!REVERSED) translate([55, 30, 0]) CircleAirVentPattern(h=2*WALL_THICKNESS, d=40);
                    } else {
                        // Cooling: exhaust for 2 4010 fan
                        translate([BOX_WIDTH/2,MAINBOARD_POSITION.y-LCD_LENGTH-(CREALITY_MELZI_BOARD ? 10 : 0),0]) {
                            translate([0, 22, 0]) CircleAirVentPattern(h=2*WALL_THICKNESS, d=39);
                            translate([0, -22, 0]) CircleAirVentPattern(h=2*WALL_THICKNESS, d=39);
                        }
                    }
                    // Assembly: screw hole for the bottom
                    translate([REVERSED ? 30.3 : 70.6, BOX_LENGTH-LCD_LENGTH-8.4, 0]) {
                        cylinder(d=screw_hole_diameter(3), h=WALL_THICKNESS);
                        translate([0, 0, WALL_THICKNESS]) cylinder(d=2*screw_hole_diameter(3), h=WALL_THICKNESS);
                    }
                    Ender3Logo();
                }
                Support() {
                    // Support for the screw hole so it does not create a 90 degrees overhang.
                    translate([REVERSED ? 30.3 : 70.6, BOX_LENGTH-LCD_LENGTH-8.4, WALL_THICKNESS-LAYER_HEIGHT]) cylinder(d=screw_hole_diameter(3), h=LAYER_HEIGHT);
                }
            }
        }
}

module ScreenBoxTopLogo() {
    ScreenBoxTop(logo=1);
}

module FanTunnelPositioned() {
    color(FANTUNNEL_COLOR) {
        FanTunnel(LEVEL_HEIGHT, !REVERSED);
    }
}

module ScreenBox() {
    ScreenBoxFront();
    ScreenBoxBack();
    UpperLevel();
    ScreenBoxTop();
    ScreenBoxTopLogo();
    FanTunnelPositioned();
}

module RaspberryPiStandoffs() {
    translate(RASPBERRY_PI_POSITION - [REVERSED ? 20 : 0,0,0]) {
        if (AIY_KIT) {
            color(PCBPIN_COLOR) {
                translate([-8.2,-26, 22]) mirror([0,0,1]) PCBPin();
                translate([52.2,25.8, 22]) mirror([0,0,1]) PCBPin();
            }
            color(STANDOFF_COLOR) {
                translate([-8.2,-26, 19]) mirror([0,0,1]) RaspberryPiStandoff();
                translate([52.2,25.8, 19]) mirror([0,0,1]) RaspberryPiStandoff();
            }
        } else {
            color(PCBPIN_COLOR) {
                translate([-7,-26, 8]) mirror([0,0,1]) PCBPin();
                translate([51,24.5, 8]) mirror([0,0,1]) PCBPin();
            }
        }
    }
}

module AllComponents() {
    Components(LEVEL_HEIGHT, BOX_HEIGHT);
    RaspberryPiStandoffs();
}

module WithEnder3() {
    translate([REVERSED ? 433 : 0, 0, 0]) {
        translate([-BOX_WIDTH,0,0]) {
            children();
        }
        Ender3Screen();
    }
    Ender3WithoutScreen();
}

module Scene() {
    WithEnder3() {
        ScreenBox();
        AllComponents();
    }
}

Scene();