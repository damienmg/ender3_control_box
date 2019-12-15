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

// Note: this function will crash if searching for a non existant diameter.
function select_insert(d, x=0) = M_DIAMETERS[x][0] == d ? M_DIAMETERS[x] : select_insert(d, x+1);
function insert_diameter(d) = select_insert(d)[USE_INSERT == 1 ? 1 : 2];
function screw_insert_depth(d) = select_insert(d)[2];
function screwin_diameter(d) = select_insert(d)[3];
function screw_hole_diameter(d) = screwin_diameter(d)+1;


function dot(v1, v2) = v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;

function rot(v) = [v.y, v.z, v.x];

module Orientate(position=[0,0,0], direction=[0,0,-1], rotation=0, original_direction = [0,0,1]) {
    angle = acos(dot(direction, original_direction) / (norm(direction)*norm(original_direction)));
    axis = cross(original_direction, direction);
    translation = position;
    rotation_axis = norm(axis) == 0 ? [0, -direction.z, direction.y] : axis;
    translate(translation)
        rotate(rotation, direction)
            rotate(angle, norm(axis) > 0 ? axis : rot(direction))
                children();
}

module Foot(d1=6, d2=2, h=3, pos=[0,0,0], direction=[0,0,1]) {
    difference() {
        union() {
            Orientate(position=pos, direction=direction) cylinder(d=d1, h=h);
            children();
        }
        Orientate(position=pos, direction=direction) cylinder(d=d2, h=h);
    }
}

module MFoot(d=2, thickness=5, h=0, pos = [0,0,0], direction=[0,0,1]) {
    h = h > 0 ? h : screw_insert_depth(d);
    d = insert_diameter(d);
    Foot(d1=d+thickness, d2=d, h=h, pos=pos, direction=direction) {
        children();
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

function rotation_matrix(direction, angle) = (
    let(c = cos(angle))
    let(s = sin(angle))
    let(ux = direction[0]/norm(direction))
    let(uy = direction[1]/norm(direction))
    let(uz = direction[2]/norm(direction))
    let(P=[
        [ux*ux, ux*uy, ux*uz],
        [uy*ux, uy*uy, uy*uz],
        [uz*ux, uz*uy, uz*uz],
    ])
    let(I=[
        [1,0,0],
        [0,1,0],
        [0,0,1],
    ])
    let(Q=[
        [0, -uz, uy],
        [uz, 0, -ux],
        [-uy, ux, 0],
    ])
    P+c*(I-P)+s*Q
);


module RaspberryPiFeet(direction=[0,0,1], pos=[0,0,0], angle=0) {
    // 2 feet with M2 insert & 2 PCB pin feet.
    m=rotation_matrix(direction, angle);
    MFoot(pos=pos+m*[3.5,3.5,-WALL_THICKNESS], direction=direction, h=screw_insert_depth(2)+WALL_THICKNESS)
        MFoot(pos=pos+m*[52.5,61.5,-WALL_THICKNESS], direction=direction, h=screw_insert_depth(2)+WALL_THICKNESS) {
            Orientate(direction=direction, position=pos, rotation=angle) {
                translate([3.5,61.5,0]) Foot();
                translate([52.5,3.5,0]) Foot();
            }
            children();
        }
}

module BuckConverterFeet(direction=[0,0,1], pos=[0,0,0], angle=0) {
    m=rotation_matrix(direction, angle);
    // Feet with M2 insert
    MFoot(pos=[2.5,7,-WALL_THICKNESS]*m+pos, h=screw_insert_depth(2)+WALL_THICKNESS)
        MFoot(pos=[18,37,-WALL_THICKNESS]*m+pos, h=screw_insert_depth(2)+WALL_THICKNESS) {
            children();
        }
}

module RelaySwitchFeet(direction=[0,0,1], pos=[0,0,0], angle=0) {
    m=rotation_matrix(direction, angle);
    h=screw_insert_depth(3)+WALL_THICKNESS;
    // 2 feet with M2 insert & 2 feet.
    MFoot(pos=[2.2,2.2,-WALL_THICKNESS]*m+pos, h=h)
        MFoot(pos=[23.2,31.2,-WALL_THICKNESS]*m+pos, h=h) {
            Orientate(position=pos, rotation=-angle, direction=direction) {
                translate([2.2,31.2,0]) Foot(d2=0, h=h-WALL_THICKNESS);
                translate([23.2,2.2,0]) Foot(d2=0, h=h-WALL_THICKNESS);
            }
            children();
        }
}

module MiniUps24VFeet(direction=[0,0,1], pos=[0,0,0], angle=0) {
    m=rotation_matrix(direction, angle);
    h=screw_insert_depth(3)+WALL_THICKNESS;
    // 2 feet with M3 insert & 2 feet.
    MFoot(d=3, pos=[2.71,2.71,-WALL_THICKNESS]*m+pos, h=h)
        MFoot(d=3, pos=[47.29,42.09,-WALL_THICKNESS]*m+pos, h=h) {
            Orientate(position=pos, rotation=-angle, direction=direction) {
                translate([2.71,42.09,0]) Foot(d2=0, h=h-WALL_THICKNESS);
                translate([47.29,2.71,0]) Foot(d2=0, h=h-WALL_THICKNESS);
            }
            children();
        }
}