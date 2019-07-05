module VoiceHatMic() {
    rotate([-90,0,0])
        translate([59, -4, 78])
            import("voice_hat_mic.stl");
}

module VoiceHat() {
    translate([-10, 0, 13.5]) rotate([90,0,0])
        import("voice_hat.stl");
}
