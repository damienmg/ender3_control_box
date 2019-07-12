
use <../3rdparty/SKR1.3/skr13.scad>
use <../3rdparty/RaspberryPi_3B_Plus/rpi.scad>
use <../3rdparty/Fan/fan.scad>
use <../3rdparty/BuckConverter/buck_converter.scad>
use <../3rdparty/RelaySwitch/relay_switch.scad>
use <../3rdparty/AIYVoiceKit/aiy_voice_kit.scad>
include <control_box_component_positions.scad>

module Speaker3Inch() {
    $fn=100;
    it = [
        [30,30,0],
        [-30,30,0],
        [-30,-30,0],
        [30,-30,0]
    ];
    difference() {
        union() {
            cylinder(d=39.5, h=9);
            translate([0,0,9]) cylinder(d1=39.5, d2=77, h=18);
            hull() {
                translate([0,0,27]) cylinder(h=0.5, d=77);
                for(t = it)
                    translate(t + [0, 0, 27]) cylinder(h=0.5, d=6);
            }
        }
        for (t = it)
            translate(t + [0, 0, 27]) hull() {
                cylinder(h=0.5, d=4.5);
                translate(t / -norm(t)) cylinder(h=0.5, d=4.5);
            }
    }
}

module LowerLevelComponents() {
    translate([12,0,5.5])
        color([0.8,0.8,0.8]) {
            // Raspberry Pi 3B
            translate(RASPBERRY_PI_POSITION) {
                rotate([0, 0, 180]) {
                    RPi();
                    VoiceHat();
                }
            }
            // Buck converter 24V -> 5V for Raspberry Pi.
            translate([10, 227, 0]) {
                rotate([90, 0, 0])
                    BuckConverter();
            }
            // Relay for the LEDs driving 12V
            translate([70, 125, 0]) {
                rotate([0,0,90]) RelaySwitch();
            }
            // Buck converter 24V -> 12V for the LEDs
            translate([10, 253, 0]) {
                rotate([90, 0, 0])
                    BuckConverter();
            }
            // Relay for the fan, connected on the Rpi 24V input 
            translate([70, 95, 0]) {
                rotate([0,0,90]) RelaySwitch();
            }
            // Electronic Fan
            translate([32, 288, 17]) {
                rotate([90, -90, 0]) 4010Fan();
            }
            // Printer relay.
            translate([70, 65, 0]) {
                rotate([0,0,90]) RelaySwitch();
            }
        }
}         

module HigherLevelComponents(level_height) {
    translate([12,0,3.5])
        color([0.8,0.8,0.8]) {


            // SKR1.3 board
            // 0 height would be -5
            translate(MAINBOARD_POSITION + [0, 0, level_height]) {
                 SKR13();
            }

            // 5015 Fan for the TMC steppers
            translate([68,160,70.6]) {
                rotate([0, 0, 180]) {
                    5015Fan();
                }
            }
        }
}

module SideComponents(height) {
    translate([12,0,3.5])
        color([0.8,0.8,0.8]) {
            // AIY Speaker
            translate([17.5,119,37])
                rotate([0, -90, 0]) Speaker3Inch();
            
            // AIY microphone
            translate([-25, 165, height-6]) VoiceHatMic();
        }
}

module Components(level_height, height) {
    SideComponents(height);
    LowerLevelComponents();
    HigherLevelComponents(level_height);
}