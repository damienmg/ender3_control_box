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
include <control_box_component_positions.scad>

// Add support to the generated files instead of reyling on slicers.
GENERATE_SUPPORT = 1;

// This set the layer height at which the object will be printed. When we add
// the support directly from OpenSCAD, this is used to adjust the supports.
LAYER_HEIGHT = 0.2;

// Use inserts size. If set to 1, everywhere an screw is supposed to go in, a
// place for brass inserts will be added. If set to 0, simple holes in the
// plastic will be added and the screw will screw in the plastic directly. 
USE_INSERT = 1;

// TODO: AIY on/off
// TODO: Ender 3 melzi board (SKR E3 Mini).

// List of M screw diameters. Those are taken from a set of brass insert
// I bought on AliExpress. The insert diameter is the actual diameter of
// my brass minus 1 mm.
M_DIAMETERS = [
    // M size, insert diameter, insert length, screw in diameter
    [2, 3.2, 3, 1.5], // M2
    [2.5, 3.3, 5, 2], // M2.5
    [3, 5.2, 6, 2.5], // M3
    [4, 4.9, 8, 3.5], // M4
    [5, 6.4, 8, 4.5], // M5
    [6, 8.3, 10, 3.5], // M6
    [8, 10.2, 12, 4.5], // M8
    [10, 12.1, 12, 4.5], // M10
];

// Advanced parameters to set the box size, you should probably not
// change those unless you want to adapt to another printer than
// the Creality Ender-3.

BOX_WIDTH = 102;
BOX_HEIGHT = 90; //80;
LCD_SMALL_HEIGHT = 48; //44 + 2 + 2 for top
LCD_LENGTH = 100.5; //108;
// LCD_LENGTH^2 + (BOX_HEIGHT-LCD_SMALL_HEIGHT)^2 = 113^2?

BOX_LENGTH = 295;
LCD_THICKNESS = 2;
LEVEL_HEIGHT = 45;
FRONT_LENGTH = RASPBERRY_PI_POSITION[1]-30;
WALL_THICKNESS=2;