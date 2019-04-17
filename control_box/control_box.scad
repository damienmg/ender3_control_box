M2_INSERT_DIAMETER=3;

module Ender3() {
    import("../3rdparty/Ender3/Ender-3_Machine_Model.STL");
}

module RPi() {
    import("../3rdparty/RaspberryPi_3B_Plus/raspberry_pi_3_b_plus.stl");
}

module BuckConverter() {
    import("../3rdparty/BuckConverter/lm2596_buck_converter.stl");
}

module RelaySwitch() {
    height=5;
    difference() {
        cube([25.4,33.6,height]);
        translate([2.2, 2.2, 0]) cylinder(d=2.4, h=height);
        translate([25.4-2.2, 2.2, 0]) cylinder(d=2.4, h=height);
        translate([25.4-2.2, 33.6-2.4, 0]) cylinder(d=2.4, h=height);
        translate([2.2, 33.6-2.4, 0]) cylinder(d=2.4, h=height);
    }
}

module Fan() {
    import("../3rdparty/Fan/40x40x10 PC Fan.stl");
}

module BottomComponent() {
    color([0.8,0.8,0.8]) {
        // Raspberry Pi 3B
        translate([54.5,44.5,3.5]) {
            rotate([0, 0, -90])
                RPi();
        }
        // Buck converter 24V -> 5V for Raspberry Pi.
        translate([23.5,25,3.5]) {
            rotate([90, 0, 90])
                BuckConverter();
        }
        // Relay for the fan, connected on the Rpi 24V input 
        translate([4,130,3.5]) {
            RelaySwitch();
        }
        
        // Relay for the LEDs driving 12V
        translate([30,130,3.5]) {
           RelaySwitch();
        }
        // Buck converter 24V -> 12V for the LEDs
        translate([35,92,3.5]) {
            rotate([90, 0, 0]) BuckConverter();
        }

        // Printer relay, from a separate printer 24V input, output on the XT connector.
        translate([56,130,3.5]) {
           RelaySwitch();
        }
    }
}

module TopComponent() {
    color([0.8,0.8,0.8]) {
        // Fans
        translate([40,85,30]) {
            Fan();
        }
        translate([40,40,30]) {
            Fan();
        }
    }
};

module Foot(d1=6, d2=2, h=3) {
    difference() {
        cylinder(d=d1, h=h, $fn=50);
        cylinder(d=d2, h=h, $fn=50);
    }
}

module M2InsertFoot() {
    Foot(d2=M2_INSERT_DIAMETER, d1=8);
}

module PCBPin(d1=6, d2=1.7, h=3, h1=1) {
    union() {
        cylinder(d=d1, h=h1, $fn=50);
        translate([0,0,h1])
            cylinder(d=d2, h=h, $fn=50);
    }
}


module RaspberryPiStandoff(h=12, d1=6, d2=2, d3=1.7, h1=3) {
    difference() {
        PCBPin(d1=d1, d2=d3, h=h1, h1=h);
        cylinder(d=d2, h=h1, $fn=50);
    }
}

module RaspberryPiFeet() {
    translate([3.5,61.5,0]) Foot();
    translate([52.5,3.5,0]) Foot();
    // 2 feet with M2 insert
    translate([52.5,61.5,0]) M2InsertFoot();
    translate([3.5,3.5,0]) M2InsertFoot();
}

module BuckConverterFeet() {
    union() {
        // Feet with M2 insert
        translate([1.5,6,0]) M2InsertFoot();
        translate([18,37,0]) M2InsertFoot();
    }
}

module RelaySwitchFeet() {
    union() {
        translate([23.2,2.2,0]) Foot();
        translate([2.2,31.2,0]) Foot();
        // 2 Feet with M2 insert
        translate([2.2,2.2,0]) M2InsertFoot();
        translate([23.2,31.2,0]) M2InsertFoot();
    }
}

module Screw(h=36, d1=M2_INSERT_DIAMETER, d2=10) {
    difference() {
        union() {
            cube([d2-d1/2,d2, h]);
            cube([d2, d2-d1/2, h]);
            translate([d2-d1/2, d2-d1/2, 0]) cylinder(d=d1, h=h, $fn=50);
        }
        translate([d2/2, d2/2, 0])
            cylinder(d=d1, h=h, $fn=50);
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

BOX_DIMENSIONS=[85,180,39];
WALL_THICKNESS=2;
module WholeBox() {
    union() {
        difference() {
            cube(BOX_DIMENSIONS);
            translate([WALL_THICKNESS,WALL_THICKNESS,WALL_THICKNESS])
                cube([
                    BOX_DIMENSIONS.x - 2*WALL_THICKNESS,
                    BOX_DIMENSIONS.y - 2*WALL_THICKNESS,
                    BOX_DIMENSIONS.z - 2*WALL_THICKNESS]);
            // Raspberry Pi 3B ports
            translate([27.5, 0, 5])
                cube([18, WALL_THICKNESS, 15]);
            translate([45, 0, 5])
                cube([37, WALL_THICKNESS, 18]);
        }
        // Raspberry Pi 3B
        translate([26.5,22,WALL_THICKNESS])
            RaspberryPiFeet();
        // Buck converter 24V -> 5V for Raspberry Pi.
        translate([3.5,25,WALL_THICKNESS]) {
            BuckConverterFeet();
        }
        // Relay for the fan, connected on the Rpi 24V input 
        translate([4,130,WALL_THICKNESS]) {
            RelaySwitchFeet();
        }
        
        // Relay for the LEDs driving 12V
        translate([30,130,WALL_THICKNESS]) {
           RelaySwitchFeet();
        }
        // Buck converter 24V -> 12V for the LEDs
        translate([78,92.5,WALL_THICKNESS]) {
            rotate([0, 0, 90]) BuckConverterFeet();
        }
        
        // Printer relay, from a separate printer 24V input, output on the XT connector.
        translate([56,130,WALL_THICKNESS]) {
           RelaySwitchFeet();
        }
        
        // Screws for the cover
        translate([WALL_THICKNESS, WALL_THICKNESS, WALL_THICKNESS])
            Screw(BOX_DIMENSIONS.z-2*WALL_THICKNESS);
        translate([WALL_THICKNESS, BOX_DIMENSIONS.y-WALL_THICKNESS-10, WALL_THICKNESS])
            Screw(BOX_DIMENSIONS.z-2*WALL_THICKNESS);
        translate([BOX_DIMENSIONS.x-WALL_THICKNESS-10, BOX_DIMENSIONS.y-WALL_THICKNESS-10, WALL_THICKNESS])
            Screw(BOX_DIMENSIONS.z-2*WALL_THICKNESS);
        
        // Extrusion slider
        translate([0, BOX_DIMENSIONS.y, 10]) {
            AluminiumExtrusionSlider(BOX_DIMENSIONS.y-40);
        }
        translate([0, BOX_DIMENSIONS.y, 30]) {
            AluminiumExtrusionSlider(BOX_DIMENSIONS.y-50);
        }
    }
}

module LowerBox() {
    difference() {
        WholeBox();
        translate([0,0,BOX_DIMENSIONS.z-WALL_THICKNESS])
            cube([BOX_DIMENSIONS.x, BOX_DIMENSIONS.y, WALL_THICKNESS]);
    }
}

module FanHoles(h=WALL_THICKNESS) {
    union() {
        cylinder(d=40, h=WALL_THICKNESS, $fn=50);
        translate([-16,-16,0])
            cylinder(d=2.7, h=WALL_THICKNESS, $fn=50);
        translate([16,-16,0])
            cylinder(d=2.7, h=WALL_THICKNESS, $fn=50);
        translate([16,16,0])
            cylinder(d=2.7, h=WALL_THICKNESS, $fn=50);
        translate([-16,16,0])
            cylinder(d=2.7, h=WALL_THICKNESS, $fn=50);
    }
}

module CoverGuide(l=30, h=2*WALL_THICKNESS) {
    translate([0, 0, -WALL_THICKNESS/2])
        union() {
            cube([WALL_THICKNESS, l, h-WALL_THICKNESS/2]);
            translate([WALL_THICKNESS/2, 0, 0])
                rotate([-90, 0, 0])
                    cylinder(d=WALL_THICKNESS, h=l, $fn=50);
        }
}


module BoxCover() {
    z0 = BOX_DIMENSIONS.z-WALL_THICKNESS;
    union() {
        difference() {
            WholeBox();
            translate([-10,0,0]) cube([BOX_DIMENSIONS.x+10, BOX_DIMENSIONS.y, z0]);
            // Hole for the screws
            translate([WALL_THICKNESS+5, WALL_THICKNESS+5, z0])
                cylinder(d=1.7, h=WALL_THICKNESS, $fn=50);
            translate([WALL_THICKNESS+5, BOX_DIMENSIONS.y-WALL_THICKNESS-5, z0])
                cylinder(d=1.7, h=WALL_THICKNESS, $fn=50);
            translate([BOX_DIMENSIONS.x-WALL_THICKNESS-5, BOX_DIMENSIONS.y-WALL_THICKNESS-5, z0])
                cylinder(d=1.7, h=WALL_THICKNESS, $fn=50);
            // Hole for fan
            translate([40,40,z0]) FanHoles();
            translate([40,85,z0]) FanHoles();
            // Hole for the power cable with ender logo
            translate([WALL_THICKNESS+10,BOX_DIMENSIONS.y-7-2*WALL_THICKNESS,z0]) cube([BOX_DIMENSIONS.x-2*WALL_THICKNESS-20, 7, z0]);
            // Engraved logo
            translate([-30,70,z0+WALL_THICKNESS-0.5])
                scale([0.7, 0.7, 1])
                    import("../3rdparty/Ender3/Ender.stl");

            translate([-30,70,z0+WALL_THICKNESS-0.5])
                scale([0.7, 0.7, 1])
                    import("../3rdparty/Ender3/Dragon.stl");

        }
        // Guides for inserting the cover
        translate([WALL_THICKNESS, BOX_DIMENSIONS.y/2 - 15, z0-WALL_THICKNESS])
            CoverGuide();
        translate([BOX_DIMENSIONS.x - 2*WALL_THICKNESS, BOX_DIMENSIONS.y/2 - 15, z0-WALL_THICKNESS])
            CoverGuide();
        translate([BOX_DIMENSIONS.x/2+15, WALL_THICKNESS, z0-WALL_THICKNESS])
        rotate([0,0,90])
            CoverGuide();
        translate([BOX_DIMENSIONS.x/2+15, BOX_DIMENSIONS.y-2*WALL_THICKNESS, z0-WALL_THICKNESS])
        rotate([0,0,90])
            CoverGuide();
    }
}


//Ender3();
//translate([275,70,-74.5]) {
    LowerBox();
//    BoxCover();
//    TopComponent();
//    BottomComponent();
//}

// PCBPin();
//RaspberryPiStandoff();