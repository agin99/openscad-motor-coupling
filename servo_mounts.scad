use <servo_mg90s.scad>;
use <clamping_hub.scad>;

$fn = 100;

/* Dimensions:
    > total_height: 33mm

    > base_width: 22mm
    > base_depth: 12.5mm 
    > base_height: 22mm

    > bottom_to_wing: 18mm

    > wing_thickness: 2mm
    > wing_span: 31.8mm
    > wing_screw_dist: 27.7mm 

    > plinth_width: 14.5mm 
    > plinth_depth: 12.5mm
    > plinth_height: 10mm

    > spline_height: 3mm
*/
module mg90s_mount_base() {
    servo_to_base_dist = 0;

    total_height = 33;

    base_width = 23; //Measured
    base_depth = 12.5;
    base_height = 23; //Measured

    bottom_to_wing = 18;
    wing_thickness = 3; //Measured 
    wing_span = 33; //Measured
    wing_screw_dist = 27.7;
    screw_d = 2;

    plinth_width = 14.5;
    plinth_depth = 12.5;
    plinth_height = 10;
    
    spline_height = 3; 

    stand_width = (wing_span + 5 - base_width) / 2;
    stand_depth = wing_thickness + 5;

    difference() {
        cube([wing_span + 5, wing_thickness + 5, base_depth], center = true);
        rotate([90, 0, 0])
            mg90s_micro_servo_mask();
        cube([base_width, wing_thickness + 6, base_depth], center = true);

        translate([-wing_screw_dist / 2, (wing_thickness + 5) / 2, 0])
            hull() {
                translate([0, 0, -1])
                    rotate([90, 0, 0])
                        linear_extrude(1)
                            nut(screw_d);
                translate([0, 0, 1])
                    rotate([90, 0, 0])
                        linear_extrude(1)
                            nut(screw_d);
            }

        translate([wing_screw_dist / 2, (wing_thickness + 5) / 2, 0])
            hull() {
                translate([0, 0, -1])
                    rotate([90, 0, 0])
                        linear_extrude(1)
                            nut(screw_d);
                translate([0, 0, 1])
                    rotate([90, 0, 0])
                        linear_extrude(1)
                            nut(screw_d);
            }
    }

    translate([0, (base_height + 5 - (wing_thickness + 5)) / 2, -(base_depth + 4) / 2 - servo_to_base_dist])
        union() {
            cube([wing_span + 5, base_height + 5, 4], center = true);
            translate([
                -(wing_span + 5 - stand_width) / 2, 
                -(base_height + 5 - stand_depth) / 2, 
                (servo_to_base_dist + 4) / 2
            ])
                cube([stand_width, stand_depth, servo_to_base_dist], center = true);
            translate([
                (wing_span + 5 - stand_width) / 2, 
                -(base_height + 5 - stand_depth) / 2, 
                (servo_to_base_dist + 4) / 2
            ])
                cube([stand_width, stand_depth, servo_to_base_dist], center = true);
        }
}

!mg90s_mount_base();