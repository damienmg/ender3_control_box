use <../3rdparty/Ender3/ender3.scad>
use <../3rdparty/FanTunnel/fan_tunnel.scad>
use <control_box_components.scad>
include <control_box_component_positions.scad>

$fn=50;
// TODO: (in the slicer): removing support make the endcap shape break. Better to reduce the amount of support so there is none from the build plate.
// TODO: (slicer): add supports for endcap shape, narrow for extrusion slider and for frame clips.
// TODO: (slicer): no support on the border of the endcap.

M_DIAMETERS = [
    // M size, insert diameter, insert length, screw in diameter
    [2, 2.8, 3, 1.5], // M2
    [2.5, 3, 5, 2], // M2.5
    [3, 4.8, 6, 2.5], // M3
    [4, 4.5, 8, 3.5], // M4
    [5, 6, 8, 4.5], // M5
    [6, 7.5, 10, 3.5], // M6
    [8, 9.5, 12, 4.5], // M8
    [10, 11.6, 12, 4.5], // M10
];
USE_INSERT = 1;

// Note: this function will crash if searching for a non existant diameter.
function select_insert(d, x=0) = M_DIAMETERS[x][0] == d ? M_DIAMETERS[x] : select_insert(d, x+1);
function insert_diameter(d) = select_insert(d)[USE_INSERT == 1 ? 1 : 2];
function screw_insert_depth(d) = select_insert(d)[2];
function screwin_diameter(d) = select_insert(d)[3];
function screw_hole_diameter(d) = screwin_diameter()+1;

BOX_WIDTH = 102;
BOX_HEIGHT = 90; //80;
LCD_SMALL_HEIGHT = 48; //44 + 2 + 2 for top
LCD_LENGTH = 100.5; //108;
// LCD_LENGTH^2 + (BOX_HEIGHT-LCD_SMALL_HEIGHT)^2 = 113^2?
// 
BOX_LENGTH = 295;
LCD_THICKNESS = 2;
LEVEL_HEIGHT = 45;
FRONT_LENGTH = RASPBERRY_PI_POSITION[1]-30;
WALL_THICKNESS=2;

// TODO: Parameters: - AIY on/off, USB main board on/off, Insert vs screw in
// TODO: Ender 3 melzi board.

module Foot(d1=6, d2=2, h=3, pos=[0,0,0], direction=[0,0,1]) {
    difference() {
        union() {
            Orientate(position=pos, direction=direction) cylinder(d=d1, h=h);
            for (c = [0:1:$children-1])
                children(c);
        }
        Orientate(position=pos, direction=direction) cylinder(d=d2, h=h);
    }
}

module MFoot(d=2, thickness=5, h=0, pos = [0,0,0], direction=[0,0,1]) {
    h = h > 0 ? h : screw_insert_depth(d);
    d = insert_diameter(d);
    Foot(d1=d+thickness, d2=d, h=h, pos=pos, direction=direction) {
        for (c = [0:1:$children-1])
            children(c);
    }
}

module PCBPin(d1=6, d2=1.7, h=3, h1=1) {
    union() {
        cylinder(d=d1, h=h1);
        translate([0,0,h1])
            cylinder(d=d2, h=h);
    }
}


module RaspberryPiStandoff(h=12, d1=6, d2=2, d3=1.7, h1=3) {
    difference() {
        PCBPin(d1=d1, d2=d3, h=h1, h1=h);
        cylinder(d=d2, h=h1);
    }
}

module RaspberryPiFeet() {
    translate([3.5,61.5,0]) Foot();
    translate([52.5,3.5,0]) Foot();
    // 2 feet with M2 insert
    translate([52.5,61.5,0]) MFoot();
    translate([3.5,3.5,0]) MFoot();
}

module BuckConverterFeet() {
    union() {
        // Feet with M2 insert
        translate([1.5,6,0]) MFoot();
        translate([18,37,0]) MFoot();
    }
}

module RelaySwitchFeet() {
    union() {
        translate([23.2,2.2,0]) Foot();
        translate([2.2,31.2,0]) Foot();
        // 2 Feet with M2 insert
        translate([2.2,2.2,0]) MFoot();
        translate([23.2,31.2,0]) MFoot();
    }
}

module AluminiumExtrusionSlider(length=10) {
    rotate([90, -90, 0]) linear_extrude(height = length)
        polygon([
            [-2.25, 0],
            [-2.25, 3],
            [-4, 3],
            [-4, 4],
            [-2.25, 5.5],
            [2.25, 5.5],
            [4, 4],
            [4, 3],
            [2.25, 3],
            [2.25, 0],
        ]);
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

module CableBracket(h=30, w=20, depth=WALL_THICKNESS) {
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

module UpperLevel() {
    length = 130;
    translate([0, BOX_LENGTH-length, LEVEL_HEIGHT])
        difference() {
            union() {
                // Bottom
                translate([0, 0, -WALL_THICKNESS])
                    linear_extrude(WALL_THICKNESS)
                        polygon([
                            [WALL_THICKNESS, 0],
                            [10, 0],
                            [BOX_WIDTH-30, -55],
                            [BOX_WIDTH-WALL_THICKNESS, -55],
                            [BOX_WIDTH-WALL_THICKNESS, length],
                            [WALL_THICKNESS, length],
                        ]);
                // Back
                translate([WALL_THICKNESS, length, 0])
                    rotate([90, 0, 0])
                        linear_extrude(WALL_THICKNESS)
                            polygon([
                                [0, 0],
                                [BOX_WIDTH-2*WALL_THICKNESS, 0],
                                [BOX_WIDTH-2*WALL_THICKNESS, BOX_HEIGHT-LEVEL_HEIGHT-WALL_THICKNESS],
                                [0, BOX_HEIGHT-LEVEL_HEIGHT-WALL_THICKNESS]
                            ]);
                // Feet for SKR13
                translate([2.25, 5.25, 0]) {
                    translate([3.75, 3.75, 0]) MFoot(3, h=3.5);
                    translate([79.85, 3.75, 0]) MFoot(3, h=3.5);
                    translate([79.85, 105.60, 0]) MFoot(3, h=3.5);
                    translate([3.75, 105.60, 0]) MFoot(3, h=3.5);
                }
                // Support for 5015 fan
                translate([60, -20, 0]) cylinder(d=10, h=14);
                translate([33.1, -12.1, 0]) MFoot(3, h=14);
                translate([75.8, -49.7, 0]) MFoot(3, h=14);
                // Insert for air tunnel for stepper motor cooling
                translate([59.3,115.2,0]) {
                    cube([22.6,12.8,13.5]);
                    translate([0,0,13.5]) {
                        cube([WALL_THICKNESS, 12.8, 17.6]);
                        translate([20.6, 0, 0])
                            cube([WALL_THICKNESS, 12.8, 17.6]);
                        translate([0, 0, 17.6])
                            cube([22.6, 12.8, WALL_THICKNESS]);
                    }
                }
                // Cable management: bracket
                translate([87, 12.5, 0]) {
                    // Along the mainboard
                    for (p = [0:17:68])
                        translate([0, p, 0]) CableBracket(h=25, w=11, depth=2*WALL_THICKNESS);
                    translate([0, 96, 0]) CableBracket(h=25, w=11, depth=2*WALL_THICKNESS);
                }
                // Frame assembly: screw for the cover over the air vent
                translate([70.6,121.6,33]) 
                    MFoot(3, h=BOX_HEIGHT-LEVEL_HEIGHT-WALL_THICKNESS-33) {
                        translate([-11.3, -6.4, 0]) cube([22.6,12.8, BOX_HEIGHT-LEVEL_HEIGHT-WALL_THICKNESS-33]);
                    }
            }
            // Air vent for the stepper motor cooling.
            Orientate(direction=[0,1,0], position=[59.3+WALL_THICKNESS, length-WALL_THICKNESS, 13.5], rotation=-90)
                SquareAirVentPattern();
            // Cable management: cable out
            Orientate(direction=[0,1,0], position=[BOX_WIDTH-5, length-WALL_THICKNESS, 13.5], rotation=-90) {
                hull() {
                    cylinder(d=10, h=WALL_THICKNESS);
                    translate([5, 0, 0]) cylinder(d=10, h=WALL_THICKNESS);
                    translate([0, 5, 0]) cylinder(d=10, h=WALL_THICKNESS);
                    translate([5, 5, 0]) cylinder(d=10, h=WALL_THICKNESS);
                }
                // A filet to ensure no support is needed here.
                translate([10, -1, 0]) difference() {
                    cube([4, 4, WALL_THICKNESS]);
                    translate([4, 0, 0]) cylinder(d=8, h=WALL_THICKNESS);
                }
            }
            // Cable management: power in (from power management on the lower level).
            translate([11, 115, -WALL_THICKNESS]) {
                cube([42, 10, WALL_THICKNESS]);
            }

            // Cooling for the MOSFET under the board (place for heat sink)
            translate([22, 90, -WALL_THICKNESS]) {
                cube([34.5, 12, WALL_THICKNESS]);
            }
            // Frame assembly part: 2 holes for screwing to the bottom
            translate([0, 122, -WALL_THICKNESS]) {
                translate([6,0,0]) cylinder(d=screw_hole_diameter(3), h=WALL_THICKNESS);
                translate([BOX_WIDTH-WALL_THICKNESS-6,0,0]) cylinder(d=screw_hole_diameter(3), h=WALL_THICKNESS);
            }
        }
}

function dot(v1, v2) = v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;

function rot(v) = [v.y, v.z, v.x];

module Orientate(position=[0,0,0], direction=[0,0,-1], rotation=0, original_direction = [0,0,1]) {
    angle = acos(dot(direction, original_direction) / (norm(direction)*norm(original_direction)));
    axis = cross(original_direction, direction);
    translation = position;
    rotation_axis = norm(axis) == 0 ? [0, -direction.z, direction.y] : axis;
    for (c = [0:1:$children-1])
        translate(translation)
            rotate(rotation, direction)
                rotate(angle, norm(axis) > 0 ? axis : rot(direction))
                    children(c);
}

module SupportAlongLine(p1, p2, width=3, angle=45, height=4) { 
    hprime = width * tan(angle);
    Orientate(p1, p2-p1, rotation=-90)
        linear_extrude(norm(p1-p2))
            polygon([
                [0,0],
                [0,width],
                [height,width],
                [height+hprime,0]]);
}

module ScreenBorder(length = BOX_LENGTH) {
    translate([WALL_THICKNESS, 0, 0])
        rotate([0,-90,0])
            linear_extrude(WALL_THICKNESS)
                polygon([[0,0],
                        [0, length],
                        [BOX_HEIGHT, length],
                        [BOX_HEIGHT, LCD_LENGTH],
                        [LCD_SMALL_HEIGHT, 0]]);
}

module Endcap() {
    union() {
        intersection() {
            translate([21, WALL_THICKNESS, 21]) rotate([-90, 0,0])
                    Ender34040Endcap();
            translate([3, 10, 3]) hull() {
                rotate([90, 0, 0]) cylinder(r=1, h=100);
                translate([36, 0, 36]) rotate([90, 0, 0]) cylinder(r=1, h=100);
                translate([0, 0, 36]) rotate([90, 0, 0]) cylinder(r=1, h=100);
                translate([36, 0, 0]) rotate([90, 0, 0]) cylinder(r=1, h=100);
            }
        }
        translate([21, WALL_THICKNESS-4, 21]) {
            intersection() {
                rotate([-90, 0,0])
                    Ender34040Endcap();
                translate([-25, -10.2, -25]) cube([50, 10, 50]);
            }
        }
    }
}

module 40ExtrusionEndcap() {
    difference() {
        cube([40+WALL_THICKNESS,WALL_THICKNESS*2,40+WALL_THICKNESS]);
        // insert for endcap
        Endcap();
    }
}

module ScreenBoxFront(length=FRONT_LENGTH) {
    difference() {
        union() {
            // Left
            ScreenBorder(length);
            // Right
            translate([BOX_WIDTH-WALL_THICKNESS, 0, 0]) ScreenBorder(length);
            // Bottom
            cube([BOX_WIDTH, length, WALL_THICKNESS]);
            // Front with screw screw insert.
            MFoot(5, direction=[0, 1, 0], pos=[10, 0, 13], h=10)
                MFoot(5, direction=[0, 1, 0], pos=[30, 0, 33], h=10) union() {
                    cube([BOX_WIDTH, WALL_THICKNESS, LCD_SMALL_HEIGHT]);
                    cube([43, 10, 43]);
                }
            translate([BOX_WIDTH+40+WALL_THICKNESS, WALL_THICKNESS, 0]) rotate([0,0,180]) 40ExtrusionEndcap();
            // Housing frame for Speaker
            translate([0, length-WALL_THICKNESS, 0]) {
                difference() {
                    cube([32, WALL_THICKNESS, 50]);
                    cube([12, WALL_THICKNESS, 5]);
                }
            }
            translate([0, 77, 0]) {
                cube([32, WALL_THICKNESS, 50]);
                translate([32, 0, 0]) cube([WALL_THICKNESS, length-77, 50]);
                translate([20, 0, 0]) difference() {
                    cube([WALL_THICKNESS, length-77, 50]);
                    translate([0, 22, 40]) {
                        cube([WALL_THICKNESS, 41, 20]);
                        translate([0, 20.5, 0]) rotate([0, 90, 0]) cylinder(d=41, h=WALL_THICKNESS);
                    }
                }
            }
            // Relay switch feet (x3)
            translate([82.25, 124.5, WALL_THICKNESS]) rotate([0, 0, 90]) RelaySwitchFeet();
            translate([82.25, 94.5, WALL_THICKNESS]) rotate([0, 0, 90]) RelaySwitchFeet();
            translate([82.25, 64.5, WALL_THICKNESS]) rotate([0, 0, 90]) RelaySwitchFeet();
            // Assembly: frame clips
            translate([0, length+4, WALL_THICKNESS]) {
                translate([BOX_WIDTH/3-2, 0, 0]) mirror([0, 1, 0]) InsertWithFillet();
                translate([2*BOX_WIDTH/3-2, 0, 0]) mirror([0, 1, 0]) InsertWithFillet();
            }
            // Assembly: frame screws
            translate([BOX_WIDTH-10, 143, BOX_HEIGHT]) ScrewInsertForFrameAssembly();
            translate([10, 143, BOX_HEIGHT]) mirror([1,0,0]) ScrewInsertForFrameAssembly();

            // Assembly: Support for upper level
            translate([BOX_WIDTH-WALL_THICKNESS, length-WALL_THICKNESS, LEVEL_HEIGHT-WALL_THICKNESS]) {
                rotate([0,0,180]) LevelSupport(55);
                // Stop for the upper level
                translate([-10, -55, 0]) cube([10,5,10]);
            }
            // Assembly: slider for upper level (one side only)
            translate([BOX_WIDTH-WALL_THICKNESS, 120, LEVEL_HEIGHT])
                mirror([1,0,0]) UpperLevelBlocker(depth=7, height=18);
            // Assembly: Slider for 40x40 aluminium extrusion.
            // Note this part needs support.
            translate([BOX_WIDTH, 132, 30]) {
                mirror([1, 0, 0]) AluminiumExtrusionSlider(130);
            }
            translate([BOX_WIDTH, 132, 10]) {
                mirror([1, 0, 0]) AluminiumExtrusionSlider(130);
            }
        }
        // Speaker holes
        translate([0, 118, 40]) rotate([0,90,0]) union() {
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
                        depth = 3,
                        insert_depth = 0) {
    // Note: this part might need support (?)
    translate([0, 0, width]) rotate([0, 90, -90])
        union() {
            intersection() {
                cylinder(d=2*width, h=depth);
                cube([2*width, 2*width, depth]);
            }
            translate([-height, 0,0]) cube([height,width,depth]);
            translate([-height, width,0]) rotate([90, 0, 0]) linear_extrude(width) polygon([
                [0, 0],
                [0, depth+insert_depth],
                [width, depth+insert_depth],
                [width+10, depth],
                [width+10, 0],
            ]);
        }
}

module UpperLevelBlockerWithM3Insert(width = 8,
                                    height = 12,
                                    depth = 3,
                                    insert_depth = 3) {
    difference() {
        UpperLevelBlocker(width, height, depth, insert_depth);
        // Insert for the screw head.
        translate([0, 0, width]) rotate([0, 90, -90]) translate([-height+width/2, width/2, 0]) {
            cylinder(d=2*screw_hole_diameter(3), h=3.5);
            cylinder(d=screw_hole_diameter(3), h=insert_depth+depth);
        }
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
    union() {
        difference() {
            translate([0, front_length, 0]) {
                // Left
                cube([WALL_THICKNESS, BOX_LENGTH-front_length, BOX_HEIGHT]);
                // Right
                translate([BOX_WIDTH-WALL_THICKNESS, 0, 0])
                        cube([WALL_THICKNESS, BOX_LENGTH-front_length, BOX_HEIGHT]);
                // Bottom
                cube([BOX_WIDTH, BOX_LENGTH-front_length, WALL_THICKNESS]);
            }
            // Raspberry Pi Ports
            translate([0, RASPBERRY_PI_POSITION[1], 6.5]) {
                // Ethernet
                translate([0, 9, 0])
                    cube([WALL_THICKNESS, 18, 15]);
                // USB
                translate([0, -27, 0])
                    cube([WALL_THICKNESS, 37, 18]);
            }
            // Main board ports
            translate([0, MAINBOARD_POSITION[1], LEVEL_HEIGHT+4.5]) {
                // SD-card slot
                translate([0, 52, 0]) cube([WALL_THICKNESS, 15.5, 3]);
                // USB port
                translate([0, 73, 0]) cube([WALL_THICKNESS, 12.5, 11]);
            }
        }
        // Buck converter feet (x2)
        translate([65, 227.5, WALL_THICKNESS]) rotate([0,0,90]) {
            BuckConverterFeet();
            translate([26, 0, 0]) BuckConverterFeet();
        }
        // Raspberry pi feet
        translate(RASPBERRY_PI_POSITION + [-10.5, 28, WALL_THICKNESS])
            rotate([0, 0, -90]) RaspberryPiFeet();
        // Cable management: bracket
        cable_bracket_width = 10;
        cable_bracket_height = 15;
        cable_clearance = 5;
        translate([BOX_WIDTH-WALL_THICKNESS-cable_bracket_width-cable_clearance, 223, WALL_THICKNESS]) { 
            for (i = [0:26:53]) {
                translate([0, i, 0]) CableBracket(w=cable_bracket_width, h=cable_bracket_height);
            }
        }
        translate([WALL_THICKNESS+cable_clearance+cable_bracket_width, 276, WALL_THICKNESS]) rotate([0,0,180]) { 
            for (i = [0:26:53]) {
                translate([0, i, 0]) CableBracket(w=cable_bracket_width, h=cable_bracket_height);
            }
        }
        // Assembly: Support for upper level
        translate([WALL_THICKNESS, front_length, LEVEL_HEIGHT-WALL_THICKNESS])
            MFoot(3, thickness=0, pos=[4,BOX_LENGTH-front_length-8,-screw_insert_depth(3)])
                LevelSupport(BOX_LENGTH-front_length);
        translate([BOX_WIDTH-WALL_THICKNESS, BOX_LENGTH, LEVEL_HEIGHT-WALL_THICKNESS])
            rotate([0,0,180]) MFoot(3, thickness=0, pos=[6, 8, -screw_insert_depth(3)])
                LevelSupport(BOX_LENGTH-front_length);
        // Assembly: slider for upper level, containing also screw insert for the frame.
        translate([WALL_THICKNESS, front_length+7, LEVEL_HEIGHT])
            UpperLevelBlockerWithM3Insert(depth=7, insert_depth=5, height=BOX_HEIGHT-LEVEL_HEIGHT-8);
        translate([BOX_WIDTH-WALL_THICKNESS, front_length+7, LEVEL_HEIGHT])
            mirror([1,0,0]) UpperLevelBlockerWithM3Insert(depth=7, insert_depth=5, height=BOX_HEIGHT-LEVEL_HEIGHT-8);
        
        // Assembly: Slider for 40x40 aluminium extrusion.
        // Note this part needs support.
        translate([BOX_WIDTH, BOX_LENGTH-WALL_THICKNESS, 30]) {
            mirror([1, 0, 0]) AluminiumExtrusionSlider(130);
        }
        translate([BOX_WIDTH, BOX_LENGTH-WALL_THICKNESS, 10]) {
            mirror([1, 0, 0]) AluminiumExtrusionSlider(130);
        }

        // Assembly: frame clips
        translate([0, front_length-4, WALL_THICKNESS]) {
            translate([WALL_THICKNESS, 0, 0]) InsertWithFillet();
            translate([BOX_WIDTH/2-4, 0, 0]) InsertWithFillet();
            translate([BOX_WIDTH-8-WALL_THICKNESS, 0, 0]) InsertWithFillet();
        }
        // Back
        translate([0, BOX_LENGTH-WALL_THICKNESS, 0]) {
            difference() {
                cube([BOX_WIDTH, WALL_THICKNESS, LEVEL_HEIGHT-WALL_THICKNESS]);
                translate([42.2+WALL_THICKNESS, 0, 20.7+WALL_THICKNESS]) rotate([-90,0,0]) CircleAirVentPattern(d=39,h=WALL_THICKNESS);
                // Cable management: hole for 24V line in
                translate([BOX_WIDTH-5, WALL_THICKNESS, 0]) rotate([90, 0, 0]) hull() {
                    cylinder(d=10, h=WALL_THICKNESS);
                    translate([0, 5, 0]) cylinder(d=10, h=WALL_THICKNESS);
                    translate([5, 5, 0]) cylinder(d=10, h=WALL_THICKNESS);
                    translate([5, 0, 0]) cylinder(d=10, h=WALL_THICKNESS);
                }        
            }
            translate([BOX_WIDTH, 0, 0]) 40ExtrusionEndcap();
            // Frame for the fan
            translate([21.8, -10, 0]) cube([WALL_THICKNESS, 10, 40]);
            translate([64.2, -10, 0]) cube([WALL_THICKNESS, 10, 40]);
            // Mounting hole for the fan
            translate([28, 0, 6.5]) rotate([90, 0, 0]) Foot(d1=5.4, d2=select_insert(3)[3], h=3);
            translate([60, 0, 38.5]) rotate([90, 0, 0]) Foot(d1=5.4, d2=select_insert(3)[3], h=3);
        }
    }
}

module Ender3Logo() {
    // Ender 3 logo.
    translate([62, 90, 0.5]) Ender3Relief();
}

module PCBSnapFit(h=3, h2=1, d=2, d2=4) {
    // TODO: verify Snap fit works.
    difference() {
        union() {
            cylinder(d=d, h=h);
            cylinder(d1=d, d2=d2, h=h2);
        }
        translate([-d, -d/6, 0]) cube([2*d, d/3, h]);
    }
}

module ScreenBoxTop(logo=0) {
    translate([0, LCD_LENGTH, BOX_HEIGHT-WALL_THICKNESS])
        if (logo) {
            color([0.5, 0.5, 0.8]) Ender3Logo();
        } else {
            difference() {
                union() {
                    // Frame
                    translate([0, 5, WALL_THICKNESS]) cube([BOX_WIDTH, BOX_LENGTH-LCD_LENGTH-5, WALL_THICKNESS]);
                    translate([WALL_THICKNESS, 0, 0]) cube([BOX_WIDTH-2*WALL_THICKNESS, BOX_LENGTH-LCD_LENGTH, WALL_THICKNESS]);
                    // AIY mic snap fit
                    translate([17, 172.6-LCD_LENGTH,-3]) {
                        translate([69.5, -5.1, 0]) PCBSnapFit();
                        translate([69.5, 5.1, 0]) PCBSnapFit();
                        translate([0, -5.1, 0]) PCBSnapFit();
                        translate([0, 5.1, 0]) PCBSnapFit();
                    }
                    // Cooling: tunnel for the 5015 fan
                    translate([55, 30, -BOX_HEIGHT+LEVEL_HEIGHT+32]) difference() {
                        cylinder(d=40+2*WALL_THICKNESS, h=BOX_HEIGHT-LEVEL_HEIGHT-32);
                        cylinder(d=40, h=18);
                    }
                }
                // AIY mic holes
                translate([17, 172.7-LCD_LENGTH,0]) {
                    cylinder(d=3, h=2*WALL_THICKNESS);
                    translate([69.5, 0, 0]) cylinder(d=3, h=2*WALL_THICKNESS);
                    translate([24.75, -2, 0]) cube([20, 4, WALL_THICKNESS]);
                }
                // Cooling: exhaust for the 5015 fan
                translate([55, 30, 0]) CircleAirVentPattern(h=2*WALL_THICKNESS, d=40);
                // Assembly: screw hole for the bottom
                translate([70.6, BOX_LENGTH-LCD_LENGTH-8.4, 0]) {
                    cylinder(d=screw_hole_diameter(3), h=WALL_THICKNESS);
                    translate([0, 0, WALL_THICKNESS]) cylinder(d=2*screw_hole_diameter(3), h=WALL_THICKNESS);
                }
                Ender3Logo();
            }
        }
}

module ScreenBox() {
    ScreenBoxFront();
    ScreenBoxBack();
    ScreenBoxTop();
    UpperLevel();
    ScreenBoxTop(logo=1);
    FanTunnel(LEVEL_HEIGHT);
    translate([BOX_WIDTH, BOX_LENGTH-3, 0]) color([0.2,0.2,0.9]) Endcap();
    translate([BOX_WIDTH, 3, 0]) color([0.2,0.2,0.9]) mirror([0, 1, 0]) Endcap();
}

module Scene() {
    translate([-BOX_WIDTH,0,0]) {
        ScreenBox();
        Components(LEVEL_HEIGHT, BOX_HEIGHT);
    }
    Ender3Screen();
    Ender3WithoutScreen();

    // PCBPin();
    //RaspberryPiStandoff();
}

Scene();
