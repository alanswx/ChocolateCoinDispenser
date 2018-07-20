/*
 * CHANGE LOG
 *
 * 2011-09-18: Cleanup unused code + echo length of gear rack + center object + appropriate rotation for printing + added bevel to top of teeth
 * 2011-09-17: Initial version uploaded (http://www.thingiverse.com/thing:11642)
 */

pi = 3.1415926535897932384626433832795;
debug = false;

module tooth(mod,width) {
	// see http://easycalculation.com/trigonometry/triangle-angles.php
	opposite_at_reference_pitch=mod / tan(70);
	if (debug) echo("Opposite at reference pitch: ", opposite_at_reference_pitch);
	// see http://www.metrication.com/engineering/gears.html
	// see section Circular Tooth Thickness
	// see also http://www.tech.plym.ac.uk/sme/desnotes/gears/nomen1.htm
	tooth_width_at_reference_pitch=(pi / 2) * mod;
	if (debug) echo("Tooth width at reference_pitch: ", tooth_width_at_reference_pitch);
	cube_width = tooth_width_at_reference_pitch - (2 * opposite_at_reference_pitch);
	if (debug) echo("Cube width: ", cube_width);
	// see http://www.metrication.com/engineering/gears.html
	// see section Whole Depth
	opposite_of_triangle = mod < 1.25 ? 2.4 * mod : 2.25 * mod;
	if (debug) echo("Opposite_of_triangle: ", opposite_of_triangle);
	// see http://easycalculation.com/trigonometry/triangle-angles.php
	adjacent_of_triangle = opposite_of_triangle / tan(70);
	if (debug) echo("Adjacent of triangle: ", adjacent_of_triangle);
	diagonal = sqrt((opposite_of_triangle + 0.05) * (opposite_of_triangle + 0.05) + (adjacent_of_triangle * adjacent_of_triangle));
	correct_angle = 90 - acos(adjacent_of_triangle / diagonal);
	if (debug) echo("Correct angle: ", correct_angle);
	adjacent_of_mini_triangle = 0.05 / tan(90 - correct_angle);
	if (debug) echo("Adjacent of mini triangle: ", adjacent_of_mini_triangle);
	adjacent_top_cube = (0.5 * mod) / tan(45);
	translate([0,adjacent_of_mini_triangle * -1, 0]) {
		difference() {
			union() {
				intersection() {
					cube([opposite_of_triangle + 0.05,adjacent_of_triangle, width]);
					rotate([0,0,correct_angle]) cube([diagonal,adjacent_of_triangle, width]);
				}
				translate([0,adjacent_of_triangle,0]) cube([opposite_of_triangle + 0.05,cube_width, width]);
				translate([0,(adjacent_of_triangle * 2) + cube_width,width]) {
					rotate([180,0,0]) {
						intersection() {
							cube([opposite_of_triangle + 0.05,adjacent_of_triangle, width]);
							rotate([0,0,correct_angle]) cube([diagonal,adjacent_of_triangle, width]);
						}
					}
				}
			}
			translate([-0.5 * mod,-1,-0.5 * mod])cube([1 * mod + 0.05, 1+ adjacent_of_mini_triangle, width + (1 * mod)]);
			translate([-0.5 * mod,(adjacent_of_triangle * 2) + cube_width - adjacent_of_mini_triangle,-0.5 * mod]) cube([1 * mod + 0.05, 1, width + (1 * mod)]);
			translate([opposite_of_triangle + 0.05 * mod,adjacent_of_triangle - adjacent_top_cube,-0.25 * mod]) {
				rotate([0,0,45]) cube([1 * mod, 0.5 * mod,cube_width + (2 * mod)]);
			}
			translate([opposite_of_triangle + 0.05 * mod,adjacent_of_triangle - adjacent_top_cube + cube_width + 0.3 * mod,-0.25 * mod]) {
				rotate([0,0,45]) cube([0.5 * mod, 1 * mod,cube_width + (2 * mod)]);
			}
		}
	}
}

module teeth(mod,number_of_teeth,width) {
	union() {
		for (i= [0:number_of_teeth - 1]) {
			// see http://www.tech.plym.ac.uk/sme/desnotes/gears/nomen1.htm
			translate([-0.05,i * mod * pi,0]) {
				tooth(mod=mod,width=width);	
			}
		}
	}
}

module gear_rack(mod,number_of_teeth,rack_width,rack_bottom_height) {
	total_rack_length = number_of_teeth * pi * mod;
	rotate([0,90,0]) {
		translate([0,total_rack_length / 2 * -1,rack_width / 2 * -1]) {
			union() {
				teeth(mod=mod,number_of_teeth=number_of_teeth,width=rack_width);
				translate([rack_bottom_height * -1,0,0])
					cube([rack_bottom_height, number_of_teeth * pi * mod, rack_width]);
			}
		}
	}
	echo("Total length of gear rack (in mm): ", total_rack_length);
}


module holder(
   top_gap=4,
   side_gap=10,
   servo_width=20, 
   servo_length=42.5,
   gear_radius=17.8,
   servo_mount=4,
   rack_bottom_height=3.3,
   channel=9,
   tray_thickness=5.8
) {
    length=side_gap*2+servo_length;
    width=top_gap+servo_width/2+rack_bottom_height+gear_radius+tray_thickness;
    woffset=tray_thickness/2+rack_bottom_height/2;
difference(){
    
    cube([length, width, servo_mount],center=true);
    echo("woffset:",woffset);
    translate([0,woffset,0]) cube([servo_length,servo_width, servo_mount],center=true);
    }
    translate([0,-width/2+1,4])cube([length,2,servo_mount],center=true);
}

//gear_rack(mod=1.25,number_of_teeth=30,rack_width=2,rack_bottom_height=3);
//gear_rack(mod=2.5,number_of_teeth=25,rack_width=10,rack_bottom_height=3);

use <parametric_involute_gear_v5.0.scad>;
// MOD: 2.5
// Pitch radius (in mm): 18.75
// Circumference (at pitch radius, in mm): 117.80972450961724
// Basic gear script, modify to make suitable and/or pretty
gear(number_of_teeth=25,circular_pitch=450,hub_diameter=2*8.88888889,bore_diameter=6.2);
//holder();
