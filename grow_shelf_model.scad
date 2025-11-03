// Simple placeholder model (GridBeam frame + two trays)
// Replace with full v4.1 design if available
beam = 18;
tray_L = 390;
tray_W = 230;
tray_H = 70;
z_gap = 310;
$fn=64;

module beam(x,y,z){ cube([x,y,z],center=true); }

translate([0,0,0]) color("burlywood") beam(420,18,18);
translate([0,0,450]) color("burlywood") beam(420,18,18);
translate([0,0,225]) color("peru") cube([tray_L,tray_W,10],center=true);
translate([0,0,225+z_gap]) color("peru") cube([tray_L,tray_W,10],center=true);
