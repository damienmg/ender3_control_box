difference() {
    import("../3rdparty/PSU_Cover/PSU_Base_NO_USB.stl");
    translate([80,-2,4]) rotate([-90,0,0]) union() {
        cylinder(d=16, h=10, $fn=100);
        translate([-8,0,0]) cube([16,8,10]);
    }
}