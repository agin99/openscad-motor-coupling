$fn = 100;

/* Micro Servo MG90S Dimensions:
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

total_height = 33;
base_width = 23; //Measured
base_depth = 12.5;
base_height = 23; //Measured
bottom_to_wing = 18;
wing_thickness = 3; //Measured 
wing_span = 33; //Measured
wing_screw_dist = 27.7;
screw_d = 2;
plinth_width = 15;
plinth_depth = 12.5;
plinth_height = 7;
spline_height = 3;

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
    7,     //plinth_height
    3       //spline_height
];

module mg90s_micro_servo() {
    // Base
    translate([0, 0, base_height / 2])
        cube([base_width, base_depth, base_height], center = true);

    // Wing
    translate([0, 0, bottom_to_wing + wing_thickness / 2])
        difference() {
            cube([wing_span, base_depth, wing_thickness], center = true);
            
            translate([wing_screw_dist / 2, 0, 0])
                union() {
                    cylinder(d = screw_d, h = 20, center = true);
                    translate([screw_d, 0, 0]) 
                        cube([2.5, 1, wing_thickness + 1], center = true);
                }
            translate([-wing_screw_dist / 2, 0, 0])
                union() {
                    cylinder(d = screw_d, h = 20, center = true);
                    translate([-screw_d, 0, 0])
                        cube([2.5, 1, wing_thickness + 1], center = true);
                }
        }

    // Plinth
    translate([(base_width - plinth_width) / 2, 0, plinth_height / 2 + base_height])
        hull() {
            translate([(plinth_width - plinth_depth) / 2, 0, 0])
                cylinder(d = plinth_depth, h = plinth_height, center = true);
            translate([-(plinth_width - plinth_depth) / 2, 0, 0])
                cylinder(d = plinth_depth, h = plinth_height, center = true);
        }

    // Spline
    translate([
        (base_width - plinth_depth) / 2,
        0, 
        plinth_height + base_height + spline_height / 2
    ])
        cylinder(d = 5, h = spline_height, center = true);
}

/* Mask includes: 
    > Wings
    > Screw holes
*/
module mg90s_micro_servo_mask() {
    difference() {
        cube([wing_span, base_depth, wing_thickness], center = true);
        cube([base_width, base_depth + 1, wing_thickness + 1], center = true);
    }

    translate([-wing_screw_dist / 2, 0, 0])
        hull() {
            translate([0, 1, 0])
                cylinder(d = screw_d, h = 20, center = true);
            translate([0, -1, 0])
                cylinder(d = screw_d, h = 20, center = true);    
        }
    
    translate([wing_screw_dist / 2, 0, 0])
        hull() {
            translate([0, 1, 0])
                cylinder(d = screw_d, h = 20, center = true);
            translate([0, -1, 0])
                cylinder(d = screw_d, h = 20, center = true);    
        }
}

mg90s_micro_servo();
*mg90s_micro_servo_mask();