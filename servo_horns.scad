/*
===== Motor Family: Servo =====
- Performance

- Sizing

- Stock

*/

/*
===== Coupling Methods:  =====

*/

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
/*
###### MODEL: Single Horn ######

***** Mold Base Structure *****

==== Single Horn Imprint Mk. 1: ==== 
> Crown does not fit in the designated crown cylinder.
>> Chosen measurement: horn_crown_d = 6.75mm
> Fix: Try horn_crown_d = 7mm

> Horn arm not 'snap-in' tight. 
>> Chosen measurements
>>> horn_min_width = 3.75mm
>>> horn_max_width = 6.75mm
>>> horn_len = 17mm
>> Fix 1: Update parameters 
>>> horn_min_width = 4mm
>>> horn_max_width = horn_crown_d
>>> horn_len = 18.5mm [measured from center of crown]
>> Fix 2: Add parameter horn_to_len_last for use in calculating slope 
    without coupling to horn_len which is used to overcalculate len to make space 
    in the mold. 

==== Single Horn Imprint Mk. 2 ====
Parameter Set for Mk. 2: 
    - total_horn_len = 21; // from manufacturer
    - horn_crown_d = 7;
    - horn_len = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - horn_len_to_last = horn_len - (total_horn_len - 19.5); // measured from center of crown
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;

Analysis of Single Horn Imprint Mk. 2: 
1. Observation: Crown fits, with maybe a bit too much extra room. However, this is a touch up fix
    and will be addressed more 'purely' once the mold is at a starting point. 

2. Observation: Mold starts off allowing part of the horn to fit after the edge of the crown. However, 
    the slope pinches off too fast and the rest of the horn doesn't have enough room. 
>> Responsible Metric: m 
    -> *horn_min_width
    -> horn_max_width is set to the crown radius based on component geometry.
    -> *horn_len_to_last
> Fix: Keep horn_len_to_last the same and adjust horn_min_width.
    >> The slope was too steep because I was taking the slope computed from the decrease in width
        on both sides and computing that as the slope of a single edge of the horn.
    >> Mk. 2: (horn_min_width - horn_max_width) / horn_len_to_last
    >> Mk. 3: (horn_min_width - horn_max_width) / (2 * horn_len_to_last) 

3. Observation: horn_len_to_last can be simplified because the total_horn_len cancels out. 
    >> Mk. 2: horn_len_to_last = total_horn_len - (horn_len - 19.5);
    >> Mk. 3: horn_len_to_last = 19.5 - horn_crown_d / 2;

==== Single Horn Imprint Mk. 3: ====
Parameter Set for Mk. 3: 
    - total_horn_len = 21.5; // from measurement
    - horn_crown_d = 7;
    - horn_len = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - horn_len_to_last = 19.5 - horn_crown_d / 2; // measured from center of crown
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;

Analysis of Single Horn Imprint Mk. 3:
1. Observation: Horn now fits mold, cutting back on clearance to get snap-fit
> Fix: Change clearance from 0.4 -> 0.2

2. Observation: Given that the build assumption, is the servo horn span starts with the width of 
    the crown diameter, the translation of horn_crown_d / 2 - 3 = 0.5 seems is a mistake. The horn
    should fit without the need for translation. 

3. Observation: In order to test claim a successful full horn mold the mold block should accommodate
    the entirety of the mold. This means we need to extend the max value in the y = mx + b.
> Fix: Increase the length of the mold block  
    >> Mk. 3: 30
    >> Mk. 4: {Adjusted further in 4}

4. Observation: A large portion of the mold block has no interaction with the servo horn. I can increase
    print time by adjust overall block length and translating.
> Fix: Decrease length of block
    >> Mk. 3: 30
    >> Mk. 4: total_horn_len + horn_crown_d + translate[horn_crown_d, 0, 0]

5. Observation: Further print speed up can be achieved through slimming down the width of the mold.
> Fix: Decrease width of the block
    >> Mk. 3: 20
    >> Mk. 4: 12

==== Single Horn Imprint Mk. 4: ====
Parameter Set for Mk. 4: 
    - total_horn_len = 21.5; // from measurement
    - horn_crown_d = 7;
    - horn_len = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - horn_len_to_last = 19.5 - horn_crown_d / 2; // measured from center of crown
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;
    - clearance = 0.2;
    - mold_length = total_horn_len + horn_crown_d
    - mold_width = 12

Analysis of Single Horn Imprint Mk. 4:
1. Observation: Better fit, not snap-fit
> Fix: Decrease clearance: 
    >> Mk. 4: 0.2
    >> Mk. 5: 0.1

2. Observation: If snap in works too well on this one I may not be able to pull it out. 
> Fix: Create poke hole to push horn out after testing.

==== Single Horn Imprint Mk. 5: ====
Parameter Set for Mk. 5: 
    - total_horn_len = 21.5; // from measurement
    - horn_crown_d = 7;
    - horn_len = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - horn_len_to_last = 19.5 - horn_crown_d / 2; // measured from center of crown
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;
    - clearance = 0.1;
    - mold_length = total_horn_len + horn_crown_d
    - mold_width = 12

Analysis of Single Horn Imprint Mk. 5:
1. Observation: Better fit, not snap-fit
> Fix: Decrease clearance: 
    >> Mk. 5: 0.1 
    >> Mk. 6: 0

==== Single Horn Imprint Mk. 6: ====
Parameter Set for Mk. 6: 
    - total_horn_len = 21.5; // from measurement
    - horn_crown_d = 7;
    - horn_len = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - horn_len_to_last = 19.5 - horn_crown_d / 2; // measured from center of crown
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;
    - clearance = 0;
    - mold_length = total_horn_len + horn_crown_d
    - mold_width = 12

Analysis of Single Horn Imprint Mk. 6:
1. Observation: Snap-fit works! 
2. Observation: The crown configuration makes for a 'hookable' surface so I don't need a hole in the mold.

***** Fastener and Screw Hole Separation *****

1. Observation: horn_len and horn_len_to_last are improperly named and rely on a measured value that
    should be extracted to it's own value. 
> Fix: Add parameter len_to_last which is the measured distance from the farside of the crown to the 
    edge of the single horn
    >> Mk. 6: 
        -> horn_len = total_horn_len - horn_crown_d / 2;
        -> horn_len_to_last = len_to_last - horn_crown_d / 2;
    >> Mk. 7: 
        -> len_to_last = 19.5;
        -> center_to_end = total_horn_len - horn_crown_d / 2;
        -> center_to_last = len_to_last - horn_crown_d / 2;

2. Observation: The separation between the crown and first screw hole is different than
    the others which requires another measured parameter to properly adjust the start 
    point of the screw holes. 
> Fix: Add parameter len_to_first which measures the distance from the edge of the far edge
    of the crown to the center of the first hole. 

3. Its worth noting the reasoning for why I base my measurements starting at crown edge.
    The reasoning is that I find it easier to use the edge of the crown as a sturdy base
    when extending out my digital caliper to take a measurement. Also, since I already 
    know the crown diameter with reasonable accuracy (via measurement and build success)
    the computations for center-to-position isn't difficult. 

4. Observation: Even though I haven't been using the parameter screw_r thus far because 
    I'm only now working on the screw holes, screw_r is better as screw_d because of the 
    nature of mN screw naming conventions. 
> Fix: Change screw_r to screw_d

==== Single Horn Imprint Mk. 7: ====
Parameter Set for Mk. 7: 
    - total_horn_len = 21.5; // from measurement
    - len_to_last = 19.5; // from measuremnt
    - len_to_first = 8; // from measurement
    - horn_crown_d = 7; // from measurement
    - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
    - center_to_first = len_to_first - horn_crown_d / 2;
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 1;
    - hole_count = 7;
    - hole_separation = 2;
    - screw_d = 2;
    - screw_l = 20;

Analysis of Single Horn Imprint Mk. 7:
1. Observation: Unfortunately, the tools at my disposal are not capable of printing
    and measuring a hole with 1mm diameter! That being said, I usually use M2 screws 
    when coupling my servos so I'm going to use less screw holes, but places in such a 
    way that if they switch arbitrarily, without needing readjustment its a good sign 
    that the holes are properly placed and spaced. 
> Fix: Use a step size of two in the for loop i = [1: 2 : hole_count - 1] and render 
    three holes with diameter of 2mm each. 
    >> Mk. 7: hole_d = 1
    >> Mk. 8: hole_d = 2

==== Single Horn Imprint Mk. 8: ====
Parameter Set for Mk. 8: 
    - total_horn_len = 21.5; // from measurement
    - len_to_last = 19.5; // from measuremnt
    - len_to_first = 8; // from measurement
    - horn_crown_d = 7; // from measurement
    - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
    - center_to_first = len_to_first - horn_crown_d / 2;
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 2;
    - hole_count = 7;
    - hole_separation = 2;
    - screw_d = 2;
    - screw_l = 20;


Analysis of Single Horn Imprint Mk. 8:
1. Observation: Screw holes are properly spaced, however they're uniformly not far along 
    enough the horn mold. 
> Possible Responsible Metric: len_to_first
> Fix: Double checking measurement, it's possible len_to_first is 8.5mm instead of 8mm
    >> Mk. 8: len_to_first = 8
    >> Mk. 9: len_to_first = 8.5

==== Single Horn Imprint Mk. 9: ====
Parameter Set for Mk. 9: 
    - total_horn_len = 21.5; // from measurement
    - len_to_last = 19.5; // from measuremnt
    - len_to_first = 8.5; // from measurement
    - horn_crown_d = 7; // from measurement
    - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
    - center_to_first = len_to_first - horn_crown_d / 2;
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 2;
    - hole_count = 7;
    - hole_separation = 2;
    - screw_d = 2;
    - screw_l = 20;

Analysis of Single Horn Imprint Mk. 9:
1. Observation: The software predicted position of the screw hole on the horn is 11
    while the hole. 
> Possible Responsible Metric:
    >> len_to_last - it might be that the best method for hole plotting would be 
        starting from the end and moving inward. Measured against recorded 19.5, 
        I measured a possible len_to_last of 20
    >> len_to_first - 8 and 8.5 both don't sufficiently align screw holes. The screws
        are capable of threading through but they're tilted as they do so indicating 
        an incorrect line up. 
> Fix: Start from the last screw hole and plot inward instead of inward to outward. 
    >> Mk. 9: len_to_last = 19.5
    >> Mk. 10: len_to_last = 20
        for (i = [hole_count - 2: -2 : 0]) {
            echo(center_to_last - i * hole_separation);
            translate([center_to_last - i * hole_separation, 0, 0])
                cylinder(d = hole_d, h = screw_l, center = true);
        }

==== Single Horn Imprint Mk. 10: ====
Parameter Set for Mk. 10: 
    - total_horn_len = 21.5; // from measurement
    - len_to_last = 20; // from measuremnt
    - len_to_first = 8.5; // from measurement
    - horn_crown_d = 7; // from measurement
    - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
    - center_to_first = len_to_first - horn_crown_d / 2;
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 2;
    - hole_count = 7;
    - hole_separation = 2;
    - screw_d = 2;
    - screw_l = 20;

Analysis of Single Horn Imprint Mk. 10:
1. Observation: Works!
*/

module single_horn() {
    total_horn_len = 21.5; // from measurement
    len_to_last = 20; // from measuremnt
    len_to_first = 8.5;
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
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
    total_horn_len = 21.5; // from measurement
    len_to_last = 19.5; // from measuremnt
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
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

/*
###### MODEL: Double Horn ######

***** Mold Base Structure *****

==== Double Horn Imprint Mk. 1: ==== 
Parameter Set for Mk. 1: 
    - N/A

Analysis of Double Horn Imprint Mk. 1:
1. Observation: Crown does not fit in the designated crown cylinder.
>> Responsible Metric: horn_crown_d = 6.75mm
> Fix: horn_crown_d = 7mm

2. Observation: Horn arm doesn't start with crown compatible width
>> Responsible Metric: m
    -> horn_min_width
    -> horn_max_width
    -> hot fixed val of 17
> Fix: Given that we can measure the width across the end of the double horn and y = mx + b
    m = (horn_min_width - horn_max_width) / (2 * center_to_last)
    y = horn_min_width
    b = y - mx

3. Observation: Slope is to steep such that as it approaches the edge of the mold block
    the horn arms are pinched too hard and don't snap in.
> Fix: The slope was too steep because I was taking the slope computed from the decrease in width
        on both sides and computing that as the slope of a single edge of the horn.
    >> Mk. 1: (horn_min_width - horn_max_width) / horn_len_to_last
    >> Mk. 2: (horn_min_width - horn_max_width) / (2 * horn_len_to_last) 

==== Double Horn Imprint Mk. 2: ==== 
Parameter Set for Mk. 2: 
    - total_horn_len = 31.5; // from manufacturer
    - last_to_last = 28.5; // from measurement
    - horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    - center_to_end = total_horn_len / 2; // measured from center of crown
    - center_to_last = last_to_last / 2; // measured from center of crown
    - horn_min_width = 4;
    - horn_max_width = horn_crown_d;
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;
    - clearance = 0.0; // empirically (single horn) found that clearance isn't necessary
    - mold_length = total_horn_len + 5;
    - mold_width = 12; 

Analysis of Double Horn Imprint Mk. 2:
1. Observation: Horn molds are too thin.
>> Possible Responsible Metric: m 
    -> horn_min_width
    -> horn_max_width
    -> center_to_last
>> Possible Responsible Metric: b
    -> horn_min_width
    -> horn_max_width
    -> m
    -> center_to_last
>> Reason: The model uses horn_crown_d as the proxy max_width and the uses this to define the intercept.
    However, we're trying to use the slope to derive the correct intercept, which we empirically know 
    is not equal to horn_crown_d!
> Fix: We need to establish a known point on the horn where we can measure the horn width and use that
    datapoint to extrapolate the correct intercept value. The point chosen is the hole closest to the 
    crown which is easy because of the standardized distances we know the distance from the closest to
    furthest hole is 10mm. Measuring the width across as 5mm we find the slope. 
    > Add two new measured parameters:
        >> horn_closest_hole_width = 5
        >> closest_to_farthest_distance = 10
    > Compute slope using known points on the horn 
        >> m = (horn_min_width - horn_closest_hole_width) / (2 * closest_to_farthest_distance)
    > Extrapolate the line to compute the intercept using the measured center_to_last
        >> b = horn_min_width - 2 * m * center_to_last

==== Double Horn Imprint Mk. 3: ====
Parameter Set for Mk. 3: 
    - total_horn_len = 31.5; // from manufacturer
    - last_to_last = 28.5; // from measurement
    - horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    - center_to_end = total_horn_len / 2; // measured from center of crown
    - center_to_last = last_to_last / 2; // measured from center of crown
    - horn_min_width = 4; // from measurement
    - horn_closest_hole_width = 5; // from measurement
    - closest_to_farthest_distance = 10; // from measurement
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;
    - clearance = 0;

Analysis of Double Horn Imprint Mk. 3:
1. Observation: The the horn length is incorrect! The mold will not accept it.
> Reason: This happens because center_to_end/2 gets truncated in the for loop which means 15.75 -> 15 
    as the maximum x position. 
> Fix: Round up total_horn_lens.
    >> Mk. 3: x = [0 : center_to_end]
    >> Mk. 4: x = [0 : ceil(center_to_end)]

==== Double Horn Imprint Mk. 4: ====
Parameter Set for Mk. 4: 
    - total_horn_len = 31.5; // from manufacturer
    - last_to_last = 28.5; // from measurement
    - horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    - center_to_end = total_horn_len / 2; // measured from center of crown
    - center_to_last = last_to_last / 2; // measured from center of crown
    - horn_min_width = 4; // from measurement
    - horn_closest_hole_width = 5; // from measurement
    - closest_to_farthest_distance = 10; // from measurement
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;
    - clearance = 0;

Analysis of Double Horn Imprint Mk. 4: 
1. Observation: The horn length now (predictably) has extra space between it and the edge of the mold 
    due to round up. 
> Fix: Switch from rounding up to directly computing and appending the final points at x = 15.75
    >> Mk. 4: 
        top_slope = [for (x = [0 : ceil(center_to_end)]) [x, m*x + b / 2]];
        bottom_slope = [for (x = [0 : ceil(center_to_end)]) [x, -m*x - b / 2]];
    >> Mk. 5: 
        top_slope = [
            for (x = [0 : center_to_end]) [x, m*x + b / 2], 
            [center_to_end, m * center_to_end + b / 2]
        ];
        bottom_slope = [
            for (x = [0 : center_to_end]) [x, -m*x - b / 2], 
            [center_to_end, -m * center_to_end - b / 2]
        ];

2. Observation: The horn gap is slightly too wide towards the edges and the horn seems to be very slightly 
    tilted indicating the slope is not being correctly computed.
> Fix: The issue was an incorrect parenthesis in the bottom_slope polygon computation leading to an imbalance
    in the horn widths. 
    >> Mk. 4: [x, -(m*x + b) / 2]
    >> Mk. 5: [x, -m*x - b / 2]

==== Double Horn Imprint Mk. 5: ====
Parameter Set for Mk. 5: 
    - total_horn_len = 31.5; // from manufacturer
    - last_to_last = 28.5; // from measurement
    - horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    - center_to_end = total_horn_len / 2; // measured from center of crown
    - center_to_last = last_to_last / 2; // measured from center of crown
    - horn_min_width = 4; // from measurement
    - horn_closest_hole_width = 5; // from measurement
    - closest_to_farthest_distance = 10; // from measurement
    - horn_crown_height = 4.75;
    - horn_depth = 2;
    - hole_d = 1;
    - hole_separation = 2;
    - screw_r = 2;
    - clearance = 0;

Analysis of Double Horn Imprint Mk. 5: 
1. Observation: Success! It snapped in :) 

***** Fastener and Screw Hole Separation *****

- Replicate logic for single horn, across both sides of the horn. 

==== Double Horn Imprint Mk. 5: ====
Parameter Set for Mk. 6: 
    - total_horn_len = 31.5; // from manufacturer
    - last_to_last = 28.5; // from measurement
    - horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    - center_to_end = total_horn_len / 2; // measured from center of crown
    - center_to_last = last_to_last / 2; // measured from center of crown
    - horn_min_width = 4; // from measurement
    - horn_closest_hole_width = 5; // from measurement
    - closest_to_farthest_distance = 10; // from measurement
    - horn_crown_height = 4.75; // from measurement
    - horn_depth = 2; // from measurement
    - hole_count = 6;
    - hole_d = 2;
    - hole_separation = 2;
    - screw_d = 2;
    - screw_l = 20;
    - clearance = 0;

Analysis of Double Horn Imprint Mk. 5:
1. Observation: Works. 
*/

module double_horn() {
    total_horn_len = 31.5; // from manufacturer
    last_to_last = 28.5; // from measurement
    horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    center_to_end = total_horn_len / 2; // measured from center of crown
    center_to_last = last_to_last / 2; // measured from center of crown
    horn_min_width = 4; // from measurement
    horn_closest_hole_width = 5; // from measurement
    closest_to_farthest_distance = 10; // from measurement
    horn_crown_height = 4.75; // from measurement
    horn_depth = 2; // from measurement
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
    total_horn_len = 31.5; // from manufacturer
    last_to_last = 28.5; // from measurement
    horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    center_to_end = total_horn_len / 2; // measured from center of crown
    center_to_last = last_to_last / 2; // measured from center of crown
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

/*
###### MODEL: Cross Horn ######

***** Mold Base Structure *****

1. Observation: If I treat this as four distinct horns, one fat, one skinny, two straight, then I can
    replicate the single horn logic and combine all four horns on their common crown in the main module. 

2. Observation: One side of the cross horn empirically seems to be identical to the single horn dimensions. 
    This makes life a bit easier. Given the manufacturers recorded length of 33.5mm across the major axis
    of the cross horn and the 21.5mm length across the single horn, we subtract 14.5mm from 33.5mm to 
    derive the length of skinny horn, 19mm. 

3. Observation: We'll repeat the same extrapolation technique used on the double horn to find the intercept
    of the skinny horn. 

==== Cross Horn Imprint Mk. 1: ====
Parameter Set for Mk. 1: 
    > Fat horn (replicate single horn values)
        - total_horn_len = 21.5; // from measurement
        - len_to_last = 19.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4;
        - horn_max_width = horn_crown_d;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
    > Skinny horn
        - total_horn_len = 19; // from derivation - far edge of crown to edge of skinny horn
        - len_to_last = 17.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4; // from measurement
        - horn_closest_hole_width = 5.5; // from measurement
        - closest_to_farthest_distance = 10; // from measurement
        - horn_crown_height = 4.75; // from measurement
        - horn_depth = 2; // from measurement
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    > Straight horns
        - total_horn_len = 11.5; // from measurement
        - len_to_last = 9.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 3.75;
        - horn_max_width = 3.75;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;

Analysis of Cross Horn Imprint Mk. 1:
1. Observation: The fat and straight horns snap fit. The skinny horn slot is too short. Same issue as Double Horn Imprint Mk. 4 Observation 1.
> Fix: 
    Mk. 1: 
        top_slope = [for (x = [0 : center_to_end]) [x, m*x + b / 2]];
        function reverse(v) = let(max = len(v) - 1) 
            [ for (i = [0 : max]) v[max - i] ];
        bottom_slope = [for (x = [0 : center_to_end]) [x, -m*x - b / 2]];
    Mk. 2:
        top_slope = [
            for (x = [0 : center_to_end]) [x, m*x + b / 2], 
            [center_to_end, m * center_to_end + b / 2]
        ];
        bottom_slope = [
            for (x = [0 : center_to_end]) [x, -m*x - b / 2], 
            [center_to_end, -m * center_to_end - b / 2]
        ];

==== Cross Horn Imprint Mk. 2: ====
Parameter Set for Mk. 2:
    > Fat horn (replicate single horn values)
        - total_horn_len = 21.5; // from measurement
        - len_to_last = 19.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4;
        - horn_max_width = horn_crown_d;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
    > Skinny horn
        - total_horn_len = 19; // from derivation - far edge of crown to edge of skinny horn
        - len_to_last = 17.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4; // from measurement
        - horn_closest_hole_width = 5.5; // from measurement
        - closest_to_farthest_distance = 10; // from measurement
        - horn_crown_height = 4.75; // from measurement
        - horn_depth = 2; // from measurement
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    > Straight horns
        - total_horn_len = 11.5; // from measurement
        - len_to_last = 9.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 3.75;
        - horn_max_width = 3.75;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;

Analysis of Cross Horn Imprint Mk. 2:
1. Observation: Snap fit! 

2. Observation: Expand the width of the mold to cover the entirety of the straight horns
> Fix: 
    > Mk. 2: 12
    > Mk. 3: 17.5

==== Cross Horn Imprint Mk. 3: ====
Parameter Set for Mk. 3:
    > Fat horn (replicate single horn values)
        - total_horn_len = 21.5; // from measurement
        - len_to_last = 19.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4;
        - horn_max_width = horn_crown_d;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
    > Skinny horn
        - total_horn_len = 19; // from derivation - far edge of crown to edge of skinny horn
        - len_to_last = 17.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4; // from measurement
        - horn_closest_hole_width = 5.5; // from measurement
        - closest_to_farthest_distance = 10; // from measurement
        - horn_crown_height = 4.75; // from measurement
        - horn_depth = 2; // from measurement
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    > Straight horns
        - total_horn_len = 11.5; // from measurement
        - len_to_last = 9.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 3.75;
        - horn_max_width = 3.75;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    - mold_length = total_horn_len + horn_crown_d
    - mold_width = 17.5

Analysis of Cross Horn Imprint Mk. 3:
1. Observation: The extended mold of the straights horns seemed to consistently be too short on one
    side.
> Reason: Measuring the distance from the final circle to the edge of both sides shows that one straight horn 
    is longer than the other. Checking this difference in length against a few other cross horns that I have
    in my stock, this is empirically true.
> Fix: Account for the separate lengths measured to be a 0.5mm difference. This requires an update to the polygon 
    drawing as in the previous fixes for skinny horn.

2. Observation: To make this overall system more generalizable I should update the fat horn to take in the extra
    value that is usually truncated to better precision when using different dimensioned servo horns. 
> Fix: Same fixes done for observation 1.

==== Cross Horn Imprint Mk. 4: ====
Parameter Set for Mk. 4:
    > Fat horn (replicate single horn values)
        - total_horn_len = 21.5; // from measurement
        - len_to_last = 19.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4;
        - horn_max_width = horn_crown_d;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
    > Skinny horn
        - total_horn_len = 19; // from derivation - far edge of crown to edge of skinny horn
        - len_to_last = 17.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4; // from measurement
        - horn_closest_hole_width = 5.5; // from measurement
        - closest_to_farthest_distance = 10; // from measurement
        - horn_crown_height = 4.75; // from measurement
        - horn_depth = 2; // from measurement
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    > Straight horns
        - total_horn_len = 11.5 (short), 12 (long); // from measurement
        - len_to_last = 9.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 3.75;
        - horn_max_width = 3.75;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    - mold_length = total_horn_len + horn_crown_d
    - mold_width = 17.5

Analysis of Cross Horn Imprint Mk. 4:
1. Observation: Snapped in significantly easier than Mk. 3 but the mold cube is thin
    enough at the edge of the longer straight horn so the horn may have just 'broken out'
    instead of properly snapping in. 
> Fix: Extend the cube mold base outward. 
    >> Mk. 4: 17.5
    >> Mk. 5: 20

==== Cross Horn Imprint Mk. 5: ====
Parameter Set for Mk. 5:
    > Fat horn (replicate single horn values)
        - total_horn_len = 21.5; // from measurement
        - len_to_last = 19.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4;
        - horn_max_width = horn_crown_d;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
    > Skinny horn
        - total_horn_len = 19; // from derivation - far edge of crown to edge of skinny horn
        - len_to_last = 17.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 4; // from measurement
        - horn_closest_hole_width = 5.5; // from measurement
        - closest_to_farthest_distance = 10; // from measurement
        - horn_crown_height = 4.75; // from measurement
        - horn_depth = 2; // from measurement
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    > Straight horns
        - total_horn_len = 11.5 (short), 12 (long); // from measurement
        - len_to_last = 9.5; // from measuremnt
        - horn_crown_d = 7;
        - center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        - center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        - horn_min_width = 3.75;
        - horn_max_width = 3.75;
        - horn_crown_height = 4.75;
        - horn_depth = 2;
        - hole_d = 1;
        - hole_separation = 2;
        - screw_r = 2;
        - clearance = 0;
    - mold_length = total_horn_len + horn_crown_d
    - mold_width = 20

Analysis of Cross Horn Imprint Mk. 5:
1. Observation: Snap fit!

***** Fastener and Screw Hole Separation *****

- Start with a naive direct replication of single and double horn logic. 

==== Cross Horn Imprint Mk. 6: ====
Parameter Set for Mk. 5:
    > Fat horn (replicate single horn values)
        total_horn_len = 21.5; // from measurement
        len_to_last = 19.5; // from measuremnt
        horn_crown_d = 7;
        center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
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
    > Skinny horn
        total_horn_len = 19; // from derivation - far edge of crown to edge of skinny horn
        len_to_last = 17.5; // from measuremnt
        horn_crown_d = 7;
        center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
        horn_min_width = 4; // from measurement
        horn_closest_hole_width = 5.5; // from measurement
        closest_to_farthest_distance = 10; // from measurement
        horn_crown_height = 4.75; // from measurement
        horn_depth = 2; // from measurement
        hole_count = 6;
        hole_d = 2;
        hole_separation = 2;
        screw_d = 2;
        screw_l = 20;
        clearance = 0;
    > Straight horns
        total_horn_len = 11.5; // from measurement
        len_to_last = 9.5; // from measuremnt
        horn_crown_d = 7;
        //center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
        center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
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
    - mold_length = total_horn_len + horn_crown_d
    - mold_width = 20

Analysis of Cross Horn Imprint Mk. 5:
1. Observation: Works. The screw alignment could be optimized further but at this point
    they're functional for coupling cross horns into the mold.
*/
module fat_horn() {
    total_horn_len = 21.5; // from measurement
    len_to_last = 20; // from measuremnt
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
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
    total_horn_len = 19; // from derivation - far edge of crown to edge of skinny horn
    len_to_last = 17.5; // from measurement
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
    horn_min_width = 4; // from measurement
    horn_closest_hole_width = 5.5; // from measurement
    closest_to_farthest_distance = 10; // from measurement
    horn_crown_height = 4.75; // from measurement
    horn_depth = 2; // from measurement
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
    len_to_last = 9.5; // from measuremnt
    horn_crown_d = 7;
    center_to_end = total_horn_len - horn_crown_d / 2; // measured from center of crown
    center_to_last = len_to_last - horn_crown_d / 2; // measured from center of crown
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
    total_horn_len = 31.5; // from manufacturer
    last_to_last = 28.5; // from measurement
    horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    center_to_end = total_horn_len / 2; // measured from center of crown
    center_to_last = last_to_last / 2; // measured from center of crown
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
    total_horn_len = 31.5; // from manufacturer
    last_to_last = 28.5; // from measurement
    horn_crown_d = 7; // from measurement and empirical success (single horn) with value    
    center_to_end = total_horn_len / 2; // measured from center of crown
    center_to_last = last_to_last / 2; // measured from center of crown
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
cross_horn_imprint(); 