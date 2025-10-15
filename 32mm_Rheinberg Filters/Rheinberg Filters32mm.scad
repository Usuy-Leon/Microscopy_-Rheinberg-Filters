
/* 
                            Rheinberg FiltersFilters v2.0
                   

An open source filter for a costume Rheinberg Filters hat can be adapted to any compound microscope.

This 3D file is designed to be an optical filter for contrast illumination Technics for microscopy enthusiast and professionals.
     
Source :https://github.com/Usuy-Leon/DIY_Dark-Field-Filters

This project is an Open Source project,
by Usuy D. Leon, 2025.10.14
Microscopist, National University of Colombia, Bogota DC,

    */
/*                        -  Parameters -                             */
height = 1;              // Total height of the filter
outer_dia = 32;      // Outer diameter of the main structure
inner_dia = 10;       // Diameter of the light-blocking center cylinder

Inner_heigh = 0.2;           // Thickness of the inner patch in the center
border_thickness = 2;    // Thickness of the outer border
$fn = 150;                      // Resolution

/*                      - Arms Characteristics -                          */
number_arms = 3;         // Less arms = more light and information
arm_thickness = 1;        // Arm width
transition_length = 5;   // How long the taper extends from the inner circle

/*                            - Filter Build -                    */

// Border ring
border_inner_dia = outer_dia - border_thickness;

difference() {
    cylinder(h=height, d=outer_dia);
    cylinder(h=height+0.1, d=border_inner_dia);
}

// Inner blocking circle
translate([0, 0, arm_thickness/2])
    cylinder(h=Inner_heigh, d=inner_dia+0.5);

// Smooth arms
for (i = [0:number_arms-1]) {
    rotate([90, 0, i*(360/number_arms)]) {
        arm_with_smooth_transition();
    }
}

/* ------------------- Modules ------------------- */

// Arm with continuous slope connection
module arm_with_smooth_transition() {
    arm_length = (border_inner_dia/2 - inner_dia/2) - transition_length;

    union() {
        // Smooth taper section (inner to arm)
        translate([inner_dia/2,  arm_thickness/2, 0])
            linear_extrude(height=height)
                polygon(points=[
                    [0, -arm_thickness*0.2],
                    [0,  arm_thickness*0.2],
                    [transition_length,  arm_thickness/2],
                    [transition_length, -arm_thickness/2]
                ]);

        // Main flat part of the arm
        translate([inner_dia/2 + transition_length, -arm_thickness*0, 0])
            cube([arm_length, arm_thickness, height]);
    }
}