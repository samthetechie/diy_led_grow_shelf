// Window-Sill LED Grow Shelf – GridBeam edition (v4.1)
// True tri-joint construction with beam hole grid
// Pots now positioned closer to tray center (adjustable perimeter margin)
// Compatible with OpenSCAD 2021.01

// ================= PARAMETERS =================
// ----- Frame and geometry -----
beam = 18;            // Beam cross-section (square) in mm
hole_spacing = 25;    // Distance between bolt holes along each beam face
hole_dia = 5;         // Diameter of bolt holes (M5 bolts)
tray_L = 390;         // Tray internal length (X-axis)
tray_W = 230;         // Tray internal width (Y-axis)
tray_H = 70;          // Tray height (Z-axis)
tray_wall = 2;        // Tray wall thickness
tray_base = 3;        // Tray base thickness
tray_inner_margin = 15; // Gap between tray wall and frame
z_gap = 310;          // Vertical gap between trays (wine-bottle clearance)

// ----- Pots -----
pot_dia = 70;         // Pot diameter (mm)
pot_h = 80;           // Pot height (mm)
pots_x = 4;           // Pots along X direction
pots_y = 2;           // Pots along Y direction
pot_margin = 35;      // **NEW** inward margin from tray inner wall (mm) – controls how far pots sit toward center

// ================= DERIVED VALUES =================
frame_L = tray_L + 2 * (tray_inner_margin + tray_wall); // Overall frame span in X
frame_W = tray_W + 2 * (tray_inner_margin + tray_wall); // Overall frame span in Y
post_h = tray_H * 2 + z_gap + 3 * beam;                 // Total frame height (two trays + gap + beam thickness)

// ================= COLOR DEFINITIONS =================
colX = [0.1,0.3,0.9];    // X-axis beams (front/back)
colY = [0.1,0.7,0.1];    // Y-axis beams (sides)
colZ = [0.9,0.3,0.2];    // Vertical posts
colTray = [0.9,0.75,0.2]; // Trays
colPot = [0.4,0.2,0.05];  // Pots (brown clay look)

// ================= BEAM MODULES =================
module beamX(len) { cube([len, beam, beam], center=true); }
module beamY(len) { cube([beam, len, beam], center=true); }
module beamZ(len) { cube([beam, beam, len], center=true); }

// Beam with hole pattern (for visualizing GridBeam system)
module hole_grid_x(len){
    for(x=[-len/2+hole_spacing:hole_spacing:len/2-hole_spacing])
        translate([x,0,0])
            rotate([0,90,0])
                cylinder(d=hole_dia,h=beam*1.2,center=true);
}
module beam_with_holes_x(len){
    difference(){
        beamX(len);
        hole_grid_x(len);
    }
}

// ================= TRAY AND POT MODULES =================
module tray_body(l,w,h){
    // Creates hollow tray by subtracting inner volume
    difference(){
        cube([l,w,h],center=true);
        translate([0,0,tray_base])
            cube([l-2*tray_wall,w-2*tray_wall,h],center=true);
    }
}

module pot(d,h){
    // Simple tapered pot shape, hollow inside
    difference(){
        cylinder(d1=d,d2=d*0.9,h=h,center=true);
        translate([0,0,2])
            cylinder(d1=d-4,d2=(d-4)*0.9,h=h,center=true);
    }
}

module pot_grid(l,w,d,h,nx,ny,margin){
    // margin → inward distance from inner tray wall to start of grid rectangle
    usable_L = l - 2*margin; // effective span available along X
    usable_W = w - 2*margin; // effective span available along Y
    step_x = usable_L / (nx - 1); // horizontal step between pot centers
    step_y = usable_W / (ny - 1); // vertical step between pot centers
    // Place pots in an evenly spaced 2D grid
    for(ix=[0:nx-1])
        for(iy=[0:ny-1])
            translate([
                -usable_L/2 + ix*step_x,  // X coordinate of each pot
                -usable_W/2 + iy*step_y,  // Y coordinate of each pot
                h/2 - 10                  // Z placement, slightly lowered into tray
            ])
                color(colPot) pot(d,h);
}

module tray_with_pots(z0){
    // Draw tray body
    translate([0,0,z0]) color(colTray)
        tray_body(tray_L,tray_W,tray_H);
    // Draw pots, using new inward pot_margin variable
    // Increasing pot_margin moves pots toward the center of the tray
    translate([0,0,z0 - tray_H/2 + tray_base])
        pot_grid(tray_L, tray_W, pot_dia, pot_h, pots_x, pots_y, pot_margin);
}

// ================= FRAME MODULE =================
module gridbeam_frame(){
    // Bottom XY layer
    translate([0, frame_W/2 - beam/2, beam/2])
        color(colX) beam_with_holes_x(frame_L);
    translate([0, -frame_W/2 + beam/2, beam/2])
        color(colX) beam_with_holes_x(frame_L);
    translate([frame_L/2 - beam/2, 0, beam/2])
        color(colY) beamY(frame_W);
    translate([-frame_L/2 + beam/2, 0, beam/2])
        color(colY) beamY(frame_W);

    // Vertical posts (Z direction)
    for(sx=[-1,1])
        for(sy=[-1,1])
            translate([
                sx*(frame_L/2 - beam/2),
                sy*(frame_W/2 - beam/2),
                post_h/2
            ])
                color(colZ) beamZ(post_h);

    // Upper XY layer (same pattern as bottom, raised by z_gap)
    z_top = tray_H + z_gap + 1.5*beam;
    translate([0, frame_W/2 - beam/2, z_top])
        color(colX) beam_with_holes_x(frame_L);
    translate([0, -frame_W/2 + beam/2, z_top])
        color(colX) beam_with_holes_x(frame_L);
    translate([frame_L/2 - beam/2, 0, z_top])
        color(colY) beamY(frame_W);
    translate([-frame_L/2 + beam/2, 0, z_top])
        color(colY) beamY(frame_W);
}

// ================= ASSEMBLY =================
$fn = 64;
gridbeam_frame();

// Trays rest on top beams
z_lower = beam + tray_H/2;                    // height of lower tray center
z_upper = z_lower + z_gap + tray_H + beam;    // height of upper tray center

tray_with_pots(z_lower);
tray_with_pots(z_upper);
