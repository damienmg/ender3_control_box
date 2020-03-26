use <../3rdparty/Fan/fan.scad>
use <../3rdparty/Ender3/ender3.scad>
use <3rdparty/E3DV6/e3dv6.scad>
use <3rdparty/BMG/bmg.scad>
use <3rdparty/bltouch/bltouch.scad>
use <3rdparty/thingiverse/thingiverse.scad>
include <external/NopSCADlib/lib.scad>
include <params.scad>

NEMA17Pancake  = ["NEMA17",   42.3, 20,     53.6/2, 25,     11,     2,     5,     20,     31 ];

module Extruder() {
    translate([-0.4,-0.7,0.3]) rotate([0,0,-90]) %NEMA(NEMA17Pancake);
    translate([20,-3,-52]) %BMGExtruder();
}

module HotEndExtruder() {
    translate([21,0,1]) rotate([0,-90,-90])
            Extruder();
    %translate([16.6,25,-8]) rotate([180,0,-90]) E3DV6();
    %translate([-20,25,-38]) rotate([90,0,90]) 4010Fan();
}

module PartCooling() {
    rotate([130,0,180]) %5015Fan();
    translate([109,-175,53.2])
        %Prusa_45deg_fan_shroud();
}

module PositionedPartCooling() {
    translate([7,-12,-63.5]) rotate([0,0,180]) PartCooling();
}

module PositionedXCarriage() {
    translate([0, 48, -33]) rotate([0,0,-90]) %Ender3XCarriage();
}

module PositionedBLTouch() {
    translate(BLTOUCH_OFFSET+[16.5,34,-24.5]) rotate([-90,0,-90]) %BLTouch();
}

module HotEndAssembly() {
    PositionedPartCooling();
    HotEndExtruder();
    PositionedBLTouch();
    PositionedXCarriage();
}

HotEndAssembly();