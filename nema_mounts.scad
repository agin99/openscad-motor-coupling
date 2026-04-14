include <BOSL2/std.scad>
include <BOSL2/nema_steppers.scad>

$fn = 100;

/* From BOSL2: 
MOTOR_WIDTH:    The full width and length of the motor.
PLINTH_HEIGHT:  The height of the circular plinth on the face of the motor.
PLINTH_DIAM:    The diameter of the circular plinth on the face of the motor.
SCREW_SPACING:  The spacing between screwhole centers in both X and Y axes.
SCREW_SIZE:     The diameter of the screws.
SCREW_DEPTH:    The depth of the screwholes.
SHAFT_DIAM:     The diameter of the motor shaft.
*/
module nema_gusset_l_mount(size) {
    info = nema_motor_info(size);
    motor_width = info[0];
    plinth_height = info[1];

    gusset_width = 3;
    gusset_side = motor_width / 3;

    mount_screw_d = 4;

    union() {
        translate([0, 0, plinth_height])
            difference() {
                translate([gusset_side / 2, 0, 0])
                cube([
                    motor_width + gusset_side, 
                    motor_width + 2 * gusset_width, 
                    plinth_height * 2
                ], center=true);
                nema_mount_mask(size=size);
            }

        translate([
            motor_width / 2 + gusset_side + plinth_height, 
            0, 
            motor_width / 2 + gusset_side / 2
        ])
            rotate([0, 90, 0])
                difference() {
                    cube([
                        motor_width + gusset_side, 
                        motor_width + 2 * gusset_width, 
                        plinth_height * 2
                    ], center=true);
                    hull() {
                        translate([-motor_width / 3, motor_width / 3, 0])
                            cylinder(d = mount_screw_d, h = plinth_height * 2 + 1, center = true);

                        translate([motor_width / 3, motor_width / 3, 0])
                            cylinder(d = mount_screw_d, h = plinth_height * 2 + 1, center = true);
                    }

                    hull() {
                        translate([-motor_width / 3, -motor_width / 3, 0])
                            cylinder(d = mount_screw_d, h = plinth_height * 2 + 1, center = true);

                        translate([motor_width / 3, -motor_width / 3, 0])
                            cylinder(d = mount_screw_d, h = plinth_height * 2 + 1, center = true);
                    }
                }
    }

    translate([(motor_width / 2 + gusset_side), -(motor_width / 2 + gusset_width), plinth_height * 2])
        rotate([90, 0, 180])
            linear_extrude(gusset_width)
                polygon([
                    [0, 0],
                    [gusset_side, 0],
                    [0, gusset_side]
                ]);

    translate([(motor_width / 2 + gusset_side), motor_width / 2, plinth_height * 2])
        rotate([90, 0, 180])
            linear_extrude(gusset_width)
                polygon([
                    [0, 0],
                    [gusset_side, 0],
                    [0, gusset_side]
                ]);
}

module nema_test_stand(
    size,
    mod_val,
    z1, 
    z2
) {
    info = nema_motor_info(size);
    motor_width = info[0];
    plinth_height = info[1];

    gusset_width = 3;
    gusset_side = motor_width / 3;

    mount_screw_d = 4;

    ball_bearing_od = 19;

    center_distance = ((z1 + z2) * mod_val) / 2;
    gap_size = center_distance - (motor_width + 2 * gusset_width) / 2 - ball_bearing_od;

    average_center = (motor_width + 2 * gusset_width) / 2 + gap_size / 2; 

    echo(center_distance);
    echo(motor_width / 2 + gusset_width);
    echo(gap_size);

    nema_gusset_l_mount(size);

    translate([gusset_side / 2, average_center, plinth_height])
        cube([motor_width + gusset_side, gap_size, plinth_height * 2], center = true);
    translate([motor_width / 2 + gusset_side + plinth_height, average_center, motor_width / 2 + gusset_side / 2])
        rotate([0, 90, 0])
            cube([motor_width + gusset_side, gap_size, plinth_height * 2], center = true);
    difference() {
        translate([0, center_distance, 0]) {
            union() {
                translate([0, 0, plinth_height])
                    difference() {
                        translate([gusset_side / 2, 0, 0])
                        cube([
                            motor_width + gusset_side, 
                            ball_bearing_od * 2, 
                            plinth_height * 2
                        ], center=true);
                    }

                translate([
                    motor_width / 2 + gusset_side + plinth_height, 
                    0, 
                    motor_width / 2 + gusset_side / 2
                ])
                    rotate([0, 90, 0])
                        difference() {
                            cube([
                                motor_width + gusset_side, 
                                ball_bearing_od * 2, 
                                plinth_height * 2
                            ], center=true);
                        }
            }
            translate([(motor_width / 2 + gusset_side), -(ball_bearing_od), plinth_height * 2])
                rotate([90, 0, 180])
                    linear_extrude(gusset_width)
                        polygon([
                            [0, 0],
                            [gusset_side, 0],
                            [0, gusset_side]
                        ]);

            translate([(motor_width / 2 + gusset_side), ball_bearing_od - gusset_width, plinth_height * 2])
                rotate([90, 0, 180])
                    linear_extrude(gusset_width)
                        polygon([
                            [0, 0],
                            [gusset_side, 0],
                            [0, gusset_side]
                        ]);
        }

        //Ball bearing id: 5mm, od 14mm
        translate([0, center_distance, 0])
            cylinder(d = 14, h = 100, center = true);
    }
}

!nema_test_stand(
    23,
    2,
    24,
    24
);

nema_gusset_l_mount(14);