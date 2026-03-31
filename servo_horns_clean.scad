// ========== IMPORTS ========== //


// ========== GLOBAL ========== //
$fn = 100;

// ========== CONSTANTS ========== //
//TODO: Set measured parameters for single, double, and cross horns

// ==== SINGLE ==== //
single_total_len = 21.5; // From direct measurement

// ==== DOUBLE ==== //
double_total_len = 31.5; // From manufacturer

// ==== CROSS ==== //
cross_total_len = 33.5; // From manufacturer

// ========== VARIABLES ========== //


// ========== LOGIC ========== //


// ========== STRUCTURES ========== //
module single_horn() {
    total_horn_len = 21.5;
    len_to_last = 20;
    len_to_first = 8.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2;
    center_to_last = len_to_last - horn_crown_d / 2;
    center_to_first = len_to_first - horn_crown_d / 2;
    horn_min_width = 4;
    horn_max_width = horn_crown_d;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_d = 2;
    hole_count = 7;
    hole_separation = 2;
    screw_d = 2;
    screw_l = 20;

    clearance = 0;
    m = (horn_min_width - horn_max_width) / (2 * center_to_last);
    b = horn_crown_d + clearance;
    
    top_slope = [for (x = [0 : center_to_end]) [x, m*x + b / 2]];
    
    function reverse(v) = let(max = len(v) - 1) 
        [ for (i = [0 : max]) v[max - i] ];
    bottom_slope = [for (x = [0 : center_to_end]) [x, -m*x - b / 2]];

    linear_extrude(horn_depth)
        polygon(concat(top_slope, reverse(bottom_slope)));
    cylinder(d = b, h = horn_crown_height, center = true);

    for (i = [hole_count - 2: -2 : 0]) {
        echo(center_to_last - i * hole_separation);
        translate([center_to_last - i * hole_separation, 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module single_horn_imprint() {
    total_horn_len = 21.5;
    len_to_last = 19.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2;
    center_to_last = len_to_last - horn_crown_d / 2;
    horn_min_width = 4;
    horn_max_width = horn_crown_d;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_d = 1;
    hole_separation = 2;
    screw_d = 2;

    difference() {
        translate([horn_crown_d, 0, 0])
            cube([total_horn_len + horn_crown_d, 12, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                single_horn();
    }
}

module double_horn() {
    total_horn_len = 31.5;
    last_to_last = 28.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len / 2;
    center_to_last = last_to_last / 2;
    horn_min_width = 4;
    horn_closest_hole_width = 5;
    closest_to_farthest_distance = 10;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_count = 6;
    hole_d = 2;
    hole_separation = 2;
    screw_d = 2;
    screw_l = 20;
    clearance = 0;

    m = (horn_min_width - horn_closest_hole_width) / (2 * closest_to_farthest_distance);
    b = horn_min_width - 2 * m * center_to_last;

    top_slope = [
        for (x = [0 : center_to_end]) [x, m*x + b / 2], 
        [center_to_end, m * center_to_end + b / 2]
    ];
    bottom_slope = [
        for (x = [0 : center_to_end]) [x, -m*x - b / 2], 
        [center_to_end, -m * center_to_end - b / 2]
    ];
    
    function reverse(v) = let(max = len(v) - 1) 
        [ for (i = [0 : max]) v[max - i] ];

    linear_extrude(horn_depth)
        polygon(concat(top_slope, reverse(bottom_slope)));

    rotate([0, 0, 180])
        linear_extrude(horn_depth)
            polygon(concat(top_slope, reverse(bottom_slope)));
    cylinder(d = horn_crown_d + clearance, h = horn_crown_height, center = true);

    for (i = [hole_count - 2: -2 : 0]) {
        echo(center_to_last - i * hole_separation);
        translate([center_to_last - i * hole_separation, 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);

    for (i = [hole_count - 2: -2 : 0]) {
        translate([-(center_to_last - i * hole_separation), 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module double_horn_imprint() {
    total_horn_len = 31.5;
    last_to_last = 28.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len / 2;
    center_to_last = last_to_last / 2;
    horn_min_width = 4;
    horn_max_width = horn_crown_d;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_d = 1;
    hole_separation = 2;
    screw_d = 2;
    clearance = 0;

    difference() {
        cube([total_horn_len + 5, 12, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                double_horn();
    }
}

module fat_horn() {
    total_horn_len = 21.5;
    len_to_last = 20;
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2;
    center_to_last = len_to_last - horn_crown_d / 2;
    horn_min_width = 4;
    horn_max_width = horn_crown_d;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_count = 7;
    hole_d = 2;
    hole_separation = 2;
    screw_d = 2;
    screw_l = 20;
    clearance = 0;

    m = (horn_min_width - horn_max_width) / (2 * center_to_last);
    b = horn_crown_d + clearance;
    
    top_slope = [
        for (x = [0 : center_to_end]) [x, m*x + b / 2], 
        [center_to_end, m * center_to_end + b / 2]
    ];
    bottom_slope = [
        for (x = [0 : center_to_end]) [x, -m*x - b / 2], 
        [center_to_end, -m * center_to_end - b / 2]
    ];
    function reverse(v) = let(max = len(v) - 1) 
        [ for (i = [0 : max]) v[max - i] ];

    linear_extrude(horn_depth)
        polygon(concat(top_slope, reverse(bottom_slope)));
    cylinder(d = b, h = horn_crown_height, center = true);

    for (i = [hole_count: -2 : 0]) {
        translate([(center_to_last - i * hole_separation), 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module skinny_horn() {
    total_horn_len = 19;
    len_to_last = 17.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2;
    center_to_last = len_to_last - horn_crown_d / 2;
    horn_min_width = 4;
    horn_closest_hole_width = 5.5;
    closest_to_farthest_distance = 10;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_count = 6;
    hole_d = 2;
    hole_separation = 2;
    screw_d = 2;
    screw_l = 20;
    clearance = 0;

    m = (horn_min_width - horn_closest_hole_width) / (2 * closest_to_farthest_distance);
    b = horn_min_width - 2 * m * center_to_last;
    
    top_slope = [
        for (x = [0 : center_to_end]) [x, m*x + b / 2], 
        [center_to_end, m * center_to_end + b / 2]
    ];
    bottom_slope = [
        for (x = [0 : center_to_end]) [x, -m*x - b / 2], 
        [center_to_end, -m * center_to_end - b / 2]
    ];
    function reverse(v) = let(max = len(v) - 1) 
        [ for (i = [0 : max]) v[max - i] ];

    linear_extrude(horn_depth)
        polygon(concat(top_slope, reverse(bottom_slope)));
    cylinder(d = b, h = horn_crown_height, center = true);

    for (i = [hole_count: -2 : 0]) {
        echo(center_to_last - i * hole_separation)
        translate([(center_to_last - i * hole_separation), 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module straight_horn(total_horn_len) {
    len_to_last = 9.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2;
    center_to_last = len_to_last - horn_crown_d / 2;
    horn_min_width = 3.75;
    horn_max_width = 3.75;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_count = 2;
    hole_d = 2;
    hole_separation = 2;
    screw_d = 2;
    screw_l = 20;
    clearance = 0;
    
    top_slope = [
        for (x = [0 : center_to_end]) [x, horn_min_width / 2], 
        [center_to_end, horn_min_width / 2]
    ];
    bottom_slope = [
        for (x = [0 : center_to_end]) [x, -horn_min_width / 2], 
        [center_to_end, -horn_min_width / 2]
    ];
    function reverse(v) = let(max = len(v) - 1)
        [ for (i = [0 : max]) v[max - i] ];

    linear_extrude(horn_depth)
        polygon(concat(top_slope, reverse(bottom_slope)));
    cylinder(d = horn_crown_d, h = horn_crown_height, center = true);

    for (i = [hole_count - 2: -2 : 0]) {
        echo(center_to_last - i * hole_separation);
        translate([-(center_to_last - i * hole_separation), 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module cross_horn() {
    total_horn_len = 31.5;
    last_to_last = 28.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len / 2;
    center_to_last = last_to_last / 2;
    horn_min_width = 4;
    horn_max_width = horn_crown_d;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_d = 1;
    hole_separation = 2;
    screw_d = 2;
    clearance = 0;

    rotate([0, 0, 180])
        fat_horn();
    rotate([0, 0, 0])            
        skinny_horn();
    rotate([0, 0, 90])            
        straight_horn(11.5);
    rotate([0, 0, -90])            
        straight_horn(12);
}

module cross_horn_imprint() {
    total_horn_len = 31.5;
    last_to_last = 28.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len / 2;
    center_to_last = last_to_last / 2;
    horn_min_width = 4;
    horn_max_width = horn_crown_d;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_d = 1;
    hole_separation = 2;
    screw_d = 2;
    clearance = 0;
    difference() {
        cube([total_horn_len + horn_crown_d, 20, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                cross_horn();
    }
}

// ========== BUILD ========== //


// ========== ASSEMBLY ========== //
*single_horn();
*single_horn_imprint();

*double_horn();
*double_horn_imprint();

*cross_horn();
*cross_horn_imprint(); 