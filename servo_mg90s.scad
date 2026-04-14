$fn = 100;

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

total_height = 33;
base_width = 23;        //Measured
base_depth = 12.5;
base_height = 23;       //Measured
bottom_to_wing = 18;
wing_thickness = 3;     //Measured 
wing_span = 33;         //Measured
wing_screw_dist = 27.7;
screw_d = 2;
screw_l = 20;
plinth_width = 15;
plinth_depth = 12.5;
plinth_height = 7;
spline_height = 3;
spline_diam = 5;

function mg90s_micro_servo_info() = [
    33,     //total_height
    23,     //base_width
    12.5,   //base_depth
    23,     //base_height
    18,     //bottom_to_wing
    3,      //wing_thickness
    33,     //wing_span
    27.7,   //wing_screw_dist
    2,      //screw_d
    15,     //plinth_width
    12.5,   //plinth_depth
    7,      //plinth_height
    3,      //spline_height
    5       //spline_diam
];

module mg90s_micro_servo() {
    servo_wings = [wing_span, base_depth, wing_thickness];
    servo_base = [base_width, base_depth, base_height];

    // Base
    translate([0, 0, servo_base.z / 2])
        cube(servo_base, center = true);

    // Wing
    module screw_opening(side) {
        union() {
            cylinder(d = screw_d, h = 20, center = true);
            translate([(side == "l" ? screw_d : -screw_d), 0, 0]) 
                cube([2.5, 1, servo_wings.z + 1], center = true);
        }
    }
    translate([0, 0, bottom_to_wing + servo_wings.z / 2])
        difference() {
            cube(servo_wings, center = true);
            
            translate([wing_screw_dist / 2, 0, 0])
                screw_opening("l");
            translate([-wing_screw_dist / 2, 0, 0])
                screw_opening("r");
        }

    // Plinth
    translate([(servo_base.x - plinth_width) / 2, 0, plinth_height / 2 + servo_base.z])
        hull() {
            translate([(plinth_width - plinth_depth) / 2, 0, 0])
                cylinder(d = plinth_depth, h = plinth_height, center = true);
            translate([-(plinth_width - plinth_depth) / 2, 0, 0])
                cylinder(d = plinth_depth, h = plinth_height, center = true);
        }

    // Spline
    translate([
        (servo_base.x - plinth_depth) / 2,
        0, 
        plinth_height + servo_base.z + spline_height / 2
    ])
        cylinder(d = 5, h = spline_height, center = true);
}

/* Mask includes: 
    > Wings
    > Screw holes
*/
module mg90s_micro_servo_mask() { 
    // Wings
    servo_wing_block = [wing_span, base_depth, wing_thickness];
    servo_base_block = [base_width, base_depth + 1, wing_thickness + 1];
    difference() {
        cube(servo_wing_block, center = true);
        cube(servo_base_block, center = true);
    }

    // Screw holes
    module screw_hole() {
        hull() {
            translate([0, 1, 0])
                cylinder(d = screw_d, h = screw_l, center = true);
            translate([0, -1, 0])
                cylinder(d = screw_d, h = screw_l, center = true);    
        }
    }
    translate([-wing_screw_dist / 2, 0, 0])
        screw_hole();
    
    translate([wing_screw_dist / 2, 0, 0])
        screw_hole();
}

!mg90s_micro_servo();
mg90s_micro_servo_mask();