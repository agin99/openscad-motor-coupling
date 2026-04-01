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
    center_to_end = total_horn_len - horn_crown_d / 2;
    center_to_last = len_to_last - horn_crown_d / 2;

    m = (horn_min_width - horn_max_width) / (2 * min_max_dist);
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

    for (i = [hole_count - 2: -2 : 0]) {
        echo(center_to_last - i * hole_separation);
        translate([center_to_last - i * hole_separation, 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module double_horn(
    total_horn_len,
    len_to_last, // measured edge of horn to last hole on opposite side. last_to_last = 28.5; last_to_last / 2
    horn_crown_d,
    horn_min_width,
    horn_max_width,
    min_max_dist, // when extrapolating min_max_dist != len_to_last, closest_to_farthest_distance for this value
    horn_crown_height,
    horn_depth,
    hole_d,
    hole_count, 
    hole_separation,
    screw_l,
    clearance
) {
    center_to_end = total_horn_len / 2;
    center_to_last = len_to_last - total_horn_len / 2;

    m = (horn_min_width - horn_max_width) / (2 * min_max_dist);
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
    cylinder(d = horn_crown_d + clearance, h = horn_crown_height, center = true);

    for (i = [hole_count - 2: -2 : 0]) {
        translate([center_to_last - i * hole_separation, 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);

    rotate([0, 0, 180])
        linear_extrude(horn_depth)
            polygon(concat(top_slope, reverse(bottom_slope)));

    for (i = [hole_count - 2: -2 : 0]) {
        translate([-(center_to_last - i * hole_separation), 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
}

module fat_horn(
    total_horn_len,
    len_to_last, // last_to_last = 28.5; last_to_last / 2
    horn_crown_d,
    horn_min_width,
    horn_max_width,
    min_max_dist, // when extrapolating min_max_dist != len_to_last, closest_to_farthest_distance for this value
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

module skinny_horn(
    total_horn_len,
    len_to_last, // last_to_last = 28.5; last_to_last / 2
    horn_crown_d,
    horn_min_width,
    horn_max_width, // horn_closest_hole_width 
    min_max_dist, // when extrapolating min_max_dist != len_to_last, closest_to_farthest_distance for this value
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
        translate([(center_to_last - i * hole_separation), 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module straight_horn(
    total_horn_len,
    len_to_last, // last_to_last = 28.5; last_to_last / 2
    horn_crown_d,
    horn_min_width,
    horn_max_width, // horn_closest_hole_width 
    min_max_dist, // when extrapolating min_max_dist != len_to_last, closest_to_farthest_distance for this value
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
    cylinder(d = horn_crown_d, h = horn_crown_height, center = true);

    for (i = [hole_count - 2: -2 : 0]) {
        echo(center_to_last - i * hole_separation);
        translate([-(center_to_last - i * hole_separation), 0, 0])
            cylinder(d = hole_d, h = screw_l, center = true);
    }
    cylinder(d = horn_crown_d, h = screw_l, center = true);
}

module single_horn_imprint() {
    total_horn_len = 21.5;
    len_to_last = 20;
    horn_crown_d = 7;
    horn_min_width = 4;
    horn_max_width = horn_crown_d;
    min_max_dist = len_to_last - horn_crown_d / 2; 
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_d = 2;
    hole_count = 7;
    hole_separation = 2;
    screw_l = 20;
    clearance = 0;

    difference() {
        translate([horn_crown_d, 0, 0])
            cube([total_horn_len + horn_crown_d, horn_crown_d * 2, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                single_horn(
                    total_horn_len,
                    len_to_last,
                    horn_crown_d,
                    horn_min_width,
                    horn_max_width,
                    min_max_dist, // Used in place of len_to_last when not extrapolating 
                    horn_crown_height,
                    horn_depth,
                    hole_d,
                    hole_count, 
                    hole_separation,
                    screw_l,
                    clearance
                );
    }
}

module double_horn_imprint() {
    total_horn_len = 31.5;
    len_to_last = 30;
    last_to_last = 28.5;
    horn_crown_d = 7;
    horn_min_width = 4;
    horn_max_width = 5;
    min_max_dist = 10;
    horn_crown_height = 4.75;
    horn_depth = 2;
    hole_d = 2;
    hole_count = 6;
    hole_separation = 2;
    screw_l = 20;
    clearance = 0;

    difference() {
        cube([total_horn_len + horn_crown_d, horn_crown_d * 2, 5], center = true);
        translate([0, 0, 3])
            rotate([180, 0, 0])
                double_horn(
                    total_horn_len,
                    len_to_last, // last_to_last = 28.5; last_to_last / 2
                    horn_crown_d,
                    horn_min_width,
                    horn_max_width,
                    min_max_dist, // when extrapolating min_max_dist != len_to_last, closest_to_farthest_distance for this value
                    horn_crown_height,
                    horn_depth,
                    hole_d,
                    hole_count, 
                    hole_separation,
                    screw_l,
                    clearance
                );
    }
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