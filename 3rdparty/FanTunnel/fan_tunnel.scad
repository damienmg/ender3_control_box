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
 
 module FanTunnel(level_height, up=true) {
    translate([up ? 52 : -86, 300, level_height+33])
        rotate([180, 0, 90])
            import(up ? "./files/Bigtreetech_Stepper_cooler_fan_up.stl" : "./files/Bigtreetech_Stepper_cooler_fan_down.stl");
}