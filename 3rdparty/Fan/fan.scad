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

module 5015Fan() {
    import("5015/files/5015_Blower_Fan.stl");
}

module 4010Fan() {
    import("4010/40x40x10 PC Fan.stl");
}

module 8010Fan() {
    translate([0,0,-5]) rotate([90,0,0]) scale([1,0.4,1]) import("80MM_FAN.stl");
}