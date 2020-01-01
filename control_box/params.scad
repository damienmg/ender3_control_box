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

// Add support to the generated files instead of relyng on slicers.
GENERATE_SUPPORT = true;

// Add the fixation to attach to the Ender-3. By setting the next parameter to false,
// the fixation will be omitted, which make the box suitable for use with an enclosure.
ENDER3_FIXATION = true;

// Reverse the orientation, for example to mount it on the left of the printer.
REVERSED = false;

// Use a Creality Melzi main board footprint instead of a SKR 1.3
CREALITY_MELZI_BOARD = false;

// 2x4010 cooling, even with a SKR 1.3
// One of [2x4010, 4010, Blower]
COOLING = "Blower";

// Add feature to have room for the Google AIY Kit v1.
AIY_KIT = true;

// This set the layer height at which the object will be printed. When we add
// the support directly from OpenSCAD, this is used to adjust the supports.
LAYER_HEIGHT = 0.2;
EXTRUSION_WIDTH = 0.48;

// Use inserts size. If set to 1, everywhere an screw is supposed to go in, a
// place for brass inserts will be added. If set to 0, simple holes in the
// plastic will be added and the screw will screw in the plastic directly. 
USE_INSERT = 1;

// Rather than having 3 Relay Switch module, have only 2 and have room
// for a BTT Mini UPS 24V
USE_MINI_UPS = true;

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

// Advanced support behaviour
INTERFACE_LAYERS = 4;  // Number of layers to create non plain support.
GAP_LAYERS = 1;  // Number of layers to skip between support and the shape.
SUPPORT_PATTERN_DISTANCE = 3; // Distance between each line of non plain support (mm).
SUPPORT_OFFSET = (INTERFACE_LAYERS+GAP_LAYERS)*LAYER_HEIGHT;

// Advanced parameters to set the box size, you should probably not
// change those unless you want to adapt to another printer than
// the Creality Ender-3.

RASPBERRY_PI_POSITION = REVERSED ? [45,194,0] : [33,194,0];
MAINBOARD_SIZE = CREALITY_MELZI_BOARD ? [70.25, 100, 0] : [84.30, 109.67, 0];
MAINBOARD_POSITION = MAINBOARD_SIZE/2 + (
    REVERSED ? [15.7,0,0] : [2,0,0]) + (CREALITY_MELZI_BOARD ? [REVERSED ? 6 : 7,193,0] : [0,170,0]);

BOX_WIDTH = 102;
BOX_HEIGHT = 90;
LCD_SMALL_HEIGHT = 46; //44 + 2 + 2 for top
LCD_LENGTH = 100.5;
// LCD_LENGTH^2 + (BOX_HEIGHT-LCD_SMALL_HEIGHT)^2 = 113^2?

BOX_LENGTH = 295;
LCD_THICKNESS = 2;
LEVEL_HEIGHT = 45;
FRONT_LENGTH = RASPBERRY_PI_POSITION[1]-34;
WALL_THICKNESS=2;

BLOWER_COOLING = (COOLING == "Blower" && !CREALITY_MELZI_BOARD);
TWO_4010 = COOLING != "4010";

// A 1 mm offset is added when mounting on the left of the printer
// to make room for the z stepper motor.
EXTRUSION_OFFSET = REVERSED ? 0 : 1;