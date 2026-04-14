use <servo_mg90s.scad>;
use <clamping_hub.scad>;

$fn = 100;

// TODO: Add gussets
// TODO: Standardize and parameterize

/* Micro Servo MG90S Dimensions:
    > total_height: 33mm

    > base_width:   23
    > base_depth:   12.5mm 
    > base_height:  23

    > wing_width:   33
    > wing_depth:   12.5
    > wing_height:  3

    > bottom_to_wing:   18
    > wing_screw_dist:  27.7 

    > plinth_width:     15 
    > plinth_depth:     12.5
    > plinth_height:    7

    > spline_height:    3
    > spline_diam:      5
*/

module tolerant_screw_hole(separation, d, l) {
    hull() {
        translate([0, -separation / 2, 0])
            cylinder(d = d, h = l, center = true);
        translate([0, separation / 2, 0])
            cylinder(d = d, h = l, center = true);
    }
}

module tolerant_nut_trap(separation, thickness, d) {
    hull() {
        translate([0, 0, -separation / 2])
            rotate([90, 0, 0])
                linear_extrude(thickness)
                    nut(d);
        translate([0, 0, separation / 2])
            rotate([90, 0, 0])
                linear_extrude(thickness)
                    nut(d);
    }
}

module mg90s_mount_base() {
    buff_val =      5;
    total_height =  33;

    servo_base_width =    23; //Measured
    servo_base_depth =    12.5;
    servo_base_height =   23; //Measured
    servo_base = [servo_base_width, servo_base_depth, servo_base_height];

    wing_buff =     5;
    function buff(size) = size + wing_buff;
    wing_width =    buff(33);
    wing_depth =    buff(12.5);
    wing_height =   buff(3);
    wing = [wing_width, wing_depth, wing_height];

    wing_screw_dist =   27.7;

    screw_d =   2;
    screw_l =   20; 
    screw = [screw_d, screw_l];

    plinth_width =  15;
    plinth_depth =  12.5;
    plinth_height = 10;
    
    spline_diam =   5;
    spline_height = 3; 
    spline = [spline_diam, spline_height];

    support_base_width = wing.x;
    support_base_depth = servo_base.z + 5; 
    support_base_height = 5;
    support_base = [support_base_width, support_base_depth, support_base_height];

    support_col_width =   (wing.x - servo_base.x) / 2;
    support_col_depth =   wing.z;
    support_col_height =  0;
    support_col = [support_col_width, support_col_depth, support_col_height];

    mount_screw_d =     3;
    mount_screw_l =     20;
    mount_screw_dist =  6;

    nut_thickness = 1;
    nut_dist =      2;

    difference() {
        cube([wing.x, wing.z, servo_base.y], center = true);
        rotate([90, 0, 0])
            mg90s_micro_servo_mask();
        cube([servo_base.x, wing.z + 1, servo_base.y], center = true);

        translate([-wing_screw_dist / 2, (wing.z) / 2, 0])
            tolerant_nut_trap(nut_dist, nut_thickness, screw_d);

        translate([wing_screw_dist / 2, (wing.z) / 2, 0])
            tolerant_nut_trap(nut_dist, nut_thickness, screw_d);
    }

    translate([0, (support_base.y - support_col.y) / 2, -(servo_base.y + support_base.z) / 2 - support_col.z])
        difference() {
            union() {
                cube(support_base, center = true);
                translate([
                    -(support_base.x - support_col.x) / 2, 
                    -(support_base.y - support_col.y) / 2, 
                    (support_base.z + support_col.z) / 2
                ])
                    cube(support_col, center = true);
                translate([
                    (support_base.x - support_col.x) / 2, 
                    -(support_base.y - support_col.y) / 2, 
                    (support_base.z + support_col.z) / 2
                ])
                    cube(support_col, center = true);
            }

            translate([wing.x / 2 - mount_screw_d, 2, 0]) 
                tolerant_screw_hole(mount_screw_dist, mount_screw_d, mount_screw_l);
            translate([-wing.x / 2 + mount_screw_d, 2, 0])
                tolerant_screw_hole(mount_screw_dist, mount_screw_d, mount_screw_l);
        }
}

module servo_test_stand(
    mod_val,
    z1, 
    z2
) {
    buff_val =      5;
    total_height =  33;

    servo_base_width =    23; //Measured
    servo_base_depth =    12.5;
    servo_base_height =   23; //Measured
    servo_base = [servo_base_width, servo_base_depth, servo_base_height];

    wing_buff =     5;
    function buff(size) = size + wing_buff;
    wing_width =    buff(33);
    wing_depth =    buff(12.5);
    wing_height =   buff(3);
    wing = [wing_width, wing_depth, wing_height];

    base_bottom_to_wing =    18;
    wing_screw_dist =   27.7;

    screw_d =   2;
    screw_l =   20; 
    screw = [screw_d, screw_l];

    plinth_width =  15;
    plinth_depth =  12.5;
    plinth_height = 10;
    
    spline_diam =   5;
    spline_height = 3; 
    spline = [spline_diam, spline_height];

    support_base_width = wing.x;
    support_base_depth = servo_base.z + 5; 
    support_base_height = 5;
    support_base = [support_base_width, support_base_depth, support_base_height];

    support_col_width =   (wing.x - servo_base.x) / 2;
    support_col_depth =   wing.z;
    support_col_height =  0;
    support_col = [support_col_width, support_col_depth, support_col_height];

    mount_screw_d =     3;
    mount_screw_l =     20;
    mount_screw_dist =  6;

    nut_thickness = 1;
    nut_dist =      2; 

    gusset_side_l =     15;
    gusset_thickness =  3;

    center_distance = ((z1 + z2) * mod_val) / 2;
    edge_to_shaft_center = _;
    servo_shaft_height = _;

    translate([0, base_bottom_to_wing + wing.z / 2, 0])
        rotate([90, 0, 0])
            rotate([0, 0, 90])
                %mg90s_micro_servo();
    rotate([0, 90, 0]) {
        %mg90s_mount_base();
    }

    // base plate
    

    // servo gusset-l-mount yz plane
    
    
    // shaft gusset-l-mount xz plane
    
}

!mg90s_mount_base();
servo_test_stand(
    2,
    24,
    24
);