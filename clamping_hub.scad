$fn = 100;

nema_14_shaft_d = 5;
nema_17_shaft_d = 5;
nema_23_shaft_d = 8;

module nut(
    side_length
) {
    for(i = [0 : 5]) {
        rotate([0, 0, i * 60])
            polygon([
                [0, 0],
                [side_length / 2, sqrt(3) / 2 * side_length],
                [-side_length / 2, sqrt(3) / 2 * side_length],
            ]);
    }
}

module clamping_hub(
    id, 
    od, 
    clamp_thickness,
    slit_width, 
    screw_d,
    screw_l
) {
    difference() {
        union() {
            cylinder(d = od, h = clamp_thickness, center = true);
            translate([od / 2, 0, 0])
                cube([screw_d * 3, screw_d * 2.5, clamp_thickness], center = true);
        }
        cylinder(d = id, h = 100, center = true); //shaft_bore

        translate([od / 2, 0, 0]) 
            rotate([90, 0, 0])
                cylinder(d = screw_d, h = screw_l, center = true); //screw input
        translate([od / 2, screw_l / 2 + 2.5, 0]) 
            rotate([90, 0, 0])
                linear_extrude(screw_l / 2)
                    nut(screw_d); //nut trap
        
        translate([od / 2, 0, 0]) 
            rotate([0, 0, 90])
                cube([slit_width, od / 2 + screw_d, clamp_thickness], center = true); //slit

        translate([od / 2, 0, -clamp_thickness / 2 + 0.5])
            cube([screw_d * 3, screw_d * 3, 1], center = true);
    }
}

od = 15; 
clamp_thickness = 10;
slit_width = 1;
screw_d = 3;
screw_l = 20;

*clamping_hub(
    nema_23_shaft_d, 
    od, 
    clamp_thickness,
    slit_width, 
    screw_d,
    screw_l
);