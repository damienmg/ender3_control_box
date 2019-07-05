COLOR=[0.3,0.3,0.3];

module Ender3() {
    color(COLOR)
        translate([-100,200,0])
            rotate([90,0,180])
                import("Ender3.stl");
}

module Ender3Screen() {
    color(COLOR)
        translate([-102, -2, 4])
            rotate([0,-90,180])
                import("LCD.stl");
}

module Ender3WithoutScreen() {
    color(COLOR)
        translate([122,234,0])
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