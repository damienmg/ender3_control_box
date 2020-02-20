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

module Ender3() {
    %translate([-100,200,0])
        rotate([90,0,180])
            import("Ender3.stl");
}

module Ender3Screen() {
    %translate([-102, -2, 4])
        rotate([0,-90,180])
            import("LCD.stl");
}

module Ender3WithoutScreen() {
    %translate([122,234,0])
        rotate([90,0,180])
            import("Ender3-NoLCD-NoBox.stl");
}

module Ender3Relief() {
    difference() {
        import("Relief_2.stl");
        translate([-72, -10, 0]) cube([130, 100, 3]);
    }
}

module Ender34040Endcap() {
    import("4040Endcap.stl");
}

module Ender3MelziBoard() {
    translate([18.75,-61.75,-38.35]) rotate([180,0,0]) import("Control_panel.stl");
}

module Ender3XCarriageWheel(inversed=false) {
    import("625pillow.stl");
    translate([5,0,0]) import("625pillow.stl");
    translate([16,35.5,15.5]) rotate([0,90,0]) import("Rollers.stl");
    translate([8,0,0]) rotate([0,90,0]) import("Spacers_for_rollers.stl");
    translate([inversed ? -6 : 22,0,0]) rotate([0,0,inversed ? 0 : 180]) import("M5X30_Pan_Head_Screw.stl");
    translate([inversed ? 23 : -6,0,0]) rotate([0,inversed ? 90 : -90,0]) import("M5_Self-locking_nut.stl");
}

module Ender3XCarriage() {
    rotate([90,0,0]) rotate([0,90,0]) import("E_plate.stl");
    translate([-16.5,0,0]) {
        translate([0,0,-20]) Ender3XCarriageWheel(true);
        translate([0,20,20]) Ender3XCarriageWheel();
        translate([0,-20,20]) Ender3XCarriageWheel();
    }
}