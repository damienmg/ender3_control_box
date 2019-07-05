module FanTunnel(level_height) {
    // CC-BY-NC
    color([0.6, 0.8, 0.6])
        translate([52, 300, level_height+31])
            rotate([180, 0, 90])
                import("./files/Bigtreetech_Stepper_cooler_fan_up.stl");
}