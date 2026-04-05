/* 
Project Name: Servo Horn Molds
Author: Alan Gindi
Date: 4/1/2026
License: MIT
*/

// ========== IMPORTS ========== //


// ========== GLOBAL ========== //
$fn = 100;

// ========== CONSTANTS ========== //

// ==== SINGLE ==== //
single_total_horn_len = 21.5;
single_len_to_last = 20;
single_horn_crown_d = 7;
single_horn_min_width = 4;
single_horn_max_width = single_horn_crown_d;
single_min_max_dist = single_len_to_last - single_horn_crown_d / 2; 
single_horn_crown_height = 4.75;
single_horn_depth = 2;
single_hole_d = 2;
single_hole_count = 7;
single_hole_separation = 2;
single_screw_l = 20;
single_clearance = 0;

// ==== DOUBLE ==== //
double_total_horn_len = 31.5;
double_len_to_last = 30;
double_last_to_last = 28.5;
double_horn_crown_d = 7;
double_horn_min_width = 4;
double_horn_max_width = 5;
double_min_max_dist = 10;
double_horn_crown_height = 4.75;
double_horn_depth = 2;
double_hole_d = 2;
double_hole_count = 6;
double_hole_separation = 2;
double_screw_l = 20;
double_clearance = 0;

// ==== CROSS ==== //
cross_total_len = 33.5;
cross_horn_crown_d = 7;
cross_horn_crown_height = 4.75;
cross_horn_depth = 2;
cross_hole_d = 2;
cross_screw_l = 20;
cross_clearance = 0;

fat_total_horn_len = 21.5;
fat_len_to_last = 20;
fat_horn_min_width = 4;
fat_horn_max_width = cross_horn_crown_d;
fat_min_max_dist = fat_len_to_last - cross_horn_crown_d / 2;
fat_hole_count = 7;
fat_hole_separation = 2;

skinny_total_horn_len = 19;
skinny_len_to_last = 17.5;
skinny_horn_min_width = 4;
skinny_horn_max_width = 5.5;
skinny_min_max_dist = 10;
skinny_hole_count = 6;
skinny_hole_separation = 2;

str_short_total_horn_len = 11.5;
str_long_total_horn_len = 12;
str_len_to_last = 9.5;
str_horn_min_width = 3.75;
str_horn_max_width = 3.75;
str_min_max_dist = str_len_to_last - cross_horn_crown_d / 2; 
str_hole_count = 2;
str_hole_separation = 2;

// ========== VARIABLES ========== //


// ========== LOGIC ========== //


// ========== STRUCTURES ========== //
// ***** HORN TYPES ***** // 
/* 
> total_horn_len: Distance from the edge of the crown to the opposite edge of the horn.  
> len_to_last: Distance from the edge of the crown to the screw hole nearest the opposite edge of the horn. 
> horn_crown_d: Diameter of the horn crown that attaches to the spline of the servo. 
> horn_min_width: The slimmest measured part of the horn. 
> horn_max_width: The thickest measured part of the horn.
> min_max_dist: Distance between the point thickest and thinnest measured points. If absolute thickest and slimmest
    points aren't the chosen positions, the script will use the chosen points to extrapolate the equation of the line 
    and compute the actual max and min width using the measured length of the horn. 
> horn_crown_height: Height of the crown 'casing'.
> horn_depth: Depth of the horn 'arms'. 
> hole_d: Diameter of the desired screw hole.
> hole_count: Amount of screw holes on the horn. 
> hole_separation: Distance between adjacent screw holes on the horn.
> screw_l: Length of the chosen screw.
> clearance Clearance to mitigate non-ideal conditions of 3D printing. 
*/ 
module horn_base(
    total_horn_len,
    len_to_last,
    horn_crown_d,
    horn_min_width,
    horn_max_width,
    min_max_dist,
    horn_crown_height,
    horn_depth,
    hole_d,
    hole_count, 
    hole_separation,
    screw_l,
    clearance
) {
    center_to_end = total_horn_len - horn_crown_d / 2;
    center_to_last = len_to_last - horn_crown_d / 2;

    m = (horn_min_width - horn_max_width) / (2 * min_max_dist);
    b = horn_min_width - 2 * m * center_to_last + clearance;
    
    top_slope = [
        for (x = [0 : center_to_end]) [x, m*x + b / 2], 
        [center_to_end, m * center_to_end + b / 2]
    ];
    bottom_slope = [
        [center_to_end, -m * center_to_end - b / 2],
        for (x = [center_to_end: -1: 0]) [x, -m*x - b / 2]
    ];

    linear_extrude(horn_depth)
        polygon(concat(top_slope, bottom_slope));
    cylinder(d = b, h = horn_crown_height, center = true);

    for (i = [hole_count - 2: -2 : 0]) {
        translate([center_to_last - i * hole_separation, 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module single_horn(
    total_horn_len,
    len_to_last,
    horn_crown_d,
    horn_min_width,
    horn_max_width,
    min_max_dist,
    horn_crown_height,
    horn_depth,
    hole_d,
    hole_count, 
    hole_separation,
    screw_l,
    clearance
) {
    horn_base(
        total_horn_len,
        len_to_last,
        horn_crown_d,
        horn_min_width,
        horn_max_width,
        min_max_dist,
        horn_crown_height,
        horn_depth,
        hole_d,
        hole_count, 
        hole_separation,
        screw_l,
        clearance
    );
}

/*
Derivation of len_to_last - (total_horn_len - horn_crown_d) / 2 input for horn_base len_to_last input 

last_to_last = total_horn_len - 2 * (total_horn_len - len_to_last{edge to last})
             = 2 * len_to_last{edge to last} - total_horn_len

center_to_last = last_to_last / 2 
               = (2 * len_to_last{edge to last} - total_horn_len) / 2
               = len_to_last{edge to last} - total_horn_len / 2

len_to_last{horn base} = center_to_last + horn_crown_d / 2
                       = len_to_last{edge to last} - total_horn_len / 2 + horn_crown_d / 2
                       = len_to_last{edge to last} - (total_horn_len - horn_crown_d) / 2 [QED]

*/
module double_horn(
    total_horn_len,
    len_to_last,
    horn_crown_d,
    horn_min_width,
    horn_max_width,
    min_max_dist,
    horn_crown_height,
    horn_depth,
    hole_d,
    hole_count, 
    hole_separation,
    screw_l,
    clearance
) {
    horn_base(
        (total_horn_len + horn_crown_d) / 2,
        len_to_last - (total_horn_len - horn_crown_d) / 2,
        horn_crown_d,
        horn_min_width,
        horn_max_width,
        min_max_dist,
        horn_crown_height,
        horn_depth,
        hole_d,
        hole_count, 
        hole_separation,
        screw_l,
        clearance
    );
    rotate([0, 0, 180])
        horn_base(
            (total_horn_len + horn_crown_d) / 2,
            len_to_last - (total_horn_len - horn_crown_d) / 2,
            horn_crown_d,
            horn_min_width,
            horn_max_width,
            min_max_dist,
            horn_crown_height,
            horn_depth,
            hole_d,
            hole_count, 
            hole_separation,
            screw_l,
            clearance
        );
}

module cross_horn(
    horn_crown_d,
    horn_crown_height,
    horn_depth,
    hole_d,
    screw_l,
    clearance,
    fat_total_horn_len,
    fat_len_to_last,
    fat_horn_min_width,
    fat_horn_max_width,
    fat_min_max_dist,
    fat_hole_count,
    fat_hole_separation,
    skinny_total_horn_len,
    skinny_len_to_last,
    skinny_horn_min_width,
    skinny_horn_max_width,
    skinny_min_max_dist,
    skinny_hole_count,
    skinny_hole_separation,
    str_short_total_horn_len,
    str_long_total_horn_len,
    str_len_to_last,
    str_horn_min_width,
    str_horn_max_width,
    str_min_max_dist,
    str_hole_count,
    str_hole_separation
) {
    rotate([0, 0, 180])
        horn_base(
            fat_total_horn_len,
            fat_len_to_last,
            horn_crown_d,
            fat_horn_min_width,
            fat_horn_max_width,
            fat_min_max_dist,
            horn_crown_height,
            horn_depth,
            hole_d,
            fat_hole_count, 
            fat_hole_separation,
            screw_l,
            clearance
        );

    rotate([0, 0, 0])           
        horn_base(
            skinny_total_horn_len,
            skinny_len_to_last,
            horn_crown_d,
            skinny_horn_min_width,
            skinny_horn_max_width,
            skinny_min_max_dist,
            horn_crown_height,
            horn_depth,
            hole_d,
            skinny_hole_count, 
            skinny_hole_separation,
            screw_l,
            clearance
        );

    rotate([0, 0, 90])            
        horn_base(
            str_short_total_horn_len,
            str_len_to_last,
            horn_crown_d,
            str_horn_min_width,
            str_horn_max_width,
            str_min_max_dist,
            horn_crown_height,
            horn_depth,
            hole_d,
            str_hole_count, 
            str_hole_separation,
            screw_l,
            clearance
        );
    rotate([0, 0, -90])            
        horn_base(
            str_long_total_horn_len,
            str_len_to_last,
            horn_crown_d,
            str_horn_min_width,
            str_horn_max_width,
            str_min_max_dist,
            horn_crown_height,
            horn_depth,
            hole_d,
            str_hole_count, 
            str_hole_separation,
            screw_l,
            clearance
        );
}

// ***** HORN IMPRINTS ***** //
module single_horn_imprint() {
    difference() {
        translate([single_horn_crown_d, 0, 0])
            cube([single_total_horn_len + single_horn_crown_d, single_horn_crown_d * 2, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                single_horn(
                    single_total_horn_len,
                    single_len_to_last,
                    single_horn_crown_d,
                    single_horn_min_width,
                    single_horn_max_width,
                    single_min_max_dist,
                    single_horn_crown_height,
                    single_horn_depth,
                    single_hole_d,
                    single_hole_count, 
                    single_hole_separation,
                    single_screw_l,
                    single_clearance
                );
    }
}

module double_horn_imprint() {
    difference() {
        cube([double_total_horn_len + double_horn_crown_d, double_horn_crown_d * 2, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                double_horn(
                    double_total_horn_len,
                    double_len_to_last,
                    double_horn_crown_d,
                    double_horn_min_width,
                    double_horn_max_width,
                    double_min_max_dist,
                    double_horn_crown_height,
                    double_horn_depth,
                    double_hole_d,
                    double_hole_count, 
                    double_hole_separation,
                    double_screw_l,
                    double_clearance
                );
    }
}

module cross_horn_imprint() {
    difference() {
        cube([fat_total_horn_len + skinny_total_horn_len + cross_horn_crown_d, 20, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                cross_horn(
                    cross_horn_crown_d,
                    cross_horn_crown_height,
                    cross_horn_depth,
                    cross_hole_d,
                    cross_screw_l,
                    cross_clearance,
                    fat_total_horn_len,
                    fat_len_to_last,
                    fat_horn_min_width,
                    fat_horn_max_width,
                    fat_min_max_dist,
                    fat_hole_count,
                    fat_hole_separation,
                    skinny_total_horn_len,
                    skinny_len_to_last,
                    skinny_horn_min_width,
                    skinny_horn_max_width,
                    skinny_min_max_dist,
                    skinny_hole_count,
                    skinny_hole_separation,
                    str_short_total_horn_len,
                    str_long_total_horn_len,
                    str_len_to_last,
                    str_horn_min_width,
                    str_horn_max_width,
                    str_min_max_dist,
                    str_hole_count,
                    str_hole_separation
                );
    }
}

// ========== BUILD ========== //


// ========== ASSEMBLY ========== //
// Uncomment the lines below to preview the imprints
/*
translate([0, 25, 0])
    single_horn_imprint();
translate([0, 0, 0])
    double_horn_imprint();
translate([0, -25, 0])    
    cross_horn_imprint(); 
*/