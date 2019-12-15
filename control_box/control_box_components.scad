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

use <../3rdparty/SKR1.3/skr13.scad>
use <../3rdparty/RaspberryPi_3B_Plus/rpi.scad>
use <../3rdparty/Fan/fan.scad>
use <../3rdparty/BuckConverter/buck_converter.scad>
use <../3rdparty/BTT-UPS-24V/btt_ups_24v.scad>
use <../3rdparty/RelaySwitch/relay_switch.scad>
use <../3rdparty/AIYVoiceKit/aiy_voice_kit.scad>
include <colors.scad>
include <params.scad>

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
    %translate([12,0,5.5]) {
        // Raspberry Pi 3B
        translate(RASPBERRY_PI_POSITION) {
            rotate([0, 0, REVERSED ? 0 : 180]) {
                RPi();
                if (AIY_KIT) VoiceHat();
            }
        }
        // Buck converter 24V -> 5V for Raspberry Pi.
        translate([REVERSED ? 30 : 10, 231.5, 0]) {
            rotate([90, 0, 0])
                BuckConverter();
        }
        // Relay for the LEDs driving 12V
        translate([REVERSED ? 5.5 : 70, REVERSED ? 150 : 125, 2.5]) {
            rotate([0,0,REVERSED ? -90 : 90]) RelaySwitch();
        }
        // Buck converter 24V -> 12V for the LEDs
        translate([REVERSED ? 30 : 10, 255.5, 0]) {
            rotate([90, 0, 0])
                BuckConverter();
        }
        // Relay for the fan, connected on the Rpi 24V input
        translate([REVERSED ? 5.5 : 70, REVERSED ? 123 : 98, 2.5]) {
            rotate([0,0,REVERSED ? -90 : 90]) RelaySwitch();
        }
        // Electronic Fan
        translate([REVERSED ? 52 : 32, 288, 17]) {
            rotate([90, -90, 0]) 4010Fan();
        }
        // Printer relay.
        if (USE_MINI_UPS) {
            translate([REVERSED ? -1 : 76, REVERSED ? 96 : 46, 2.5]) {
                rotate([0,0,REVERSED ? -90 : 90]) BttUps24V();
            }
        } else {
            translate([REVERSED ? 5.5 : 70, REVERSED ? 95 : 70, 2.5]) {
                rotate([0,0,REVERSED ? -90 : 90]) RelaySwitch();
            }
        }
    }
}

module HigherLevelComponents(level_height, height) {
    %translate([0,0,3.5]) {
        // SKR1.3 board
        // 0 height would be -5
        translate(MAINBOARD_POSITION + [0, 0, level_height+WALL_THICKNESS]) {
                rotate([0, 0, REVERSED ? 180 : 0])
                    translate([-MAINBOARD_SIZE.x/2, -MAINBOARD_SIZE.y/2, 0])
                        SKR13();
        }
        if (BLOWER_COOLING) {
            // 5015 Fan for the TMC steppers.
            translate([80,160,70.6+WALL_THICKNESS]) {
                rotate([0, 0, 180]) {
                    5015Fan();
                }
            }
        } else {
            // 2*4010 to cool stepper driver.
            translate([BOX_WIDTH/2, MAINBOARD_POSITION.y, height-10]) {
                translate([0,22,0]) 4010Fan();
                translate([0,-22,0]) 4010Fan();
            }
        }
    }
}

module SideComponents(height) {
    if (AIY_KIT) {
        %translate([12,0,3.5]) {
            // AIY Speaker
            translate([REVERSED ? 57.5 : 17.5,119,37])
                rotate([0, REVERSED ? 90 : -90, 0]) Speaker3Inch();

            // AIY microphone
            translate([-25, BLOWER_COOLING ? 165 : 110, height-6]) VoiceHatMic();
        }
    }
}

module Components(level_height, height) {
    SideComponents(height);
    LowerLevelComponents();
    HigherLevelComponents(level_height, height);
}