/*
   Copyright 2017 Alan Steremberg
*/
// configuration

$fn=100;

boxWidth=95.5;
boxHeight=53.4;
boxThickness=12;

coinDiameter = boxHeight;
coinThickness= boxThickness;
//pipeRadius = 24.25; // black pipe
//pipeRadius = 21.40; // clear pipe
//insidePipeRadius=20.8;
insidePipeRadius=coinDiameter/2+1;
wallThickness = 2.5;
screwDiameter = 4.8;
screwRadius=screwDiameter/2;
holeOffset = 35;
flangeWidth = 90;
flangeHeight= 130;
servoPusherHoleDiameter=1.75;




// BEFORE

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


/// AFTER













//
// The pusher is the part that pushes coins out. It has a handle, and hole to hook
// a wire, that is hooked to the servo horn
//


module pusher(length){
    
    difference() {
        

    union() {
        
        
         translate([70,-21,coinThickness/2]) cube([122,11,coinThickness],center=true);
  // This is the handle on top the servo hooks to
 // translate([-length/2+7.5,0,7.5+coinThickness])
   // difference() {
   //     cube([15,5,15],center=true);
  //      rotate([90, 0, 0]) cylinder(r=servoPusherHoleDiameter/2,h=9,center=true);
  // }   
   // extrude the square minus circle into a cube with a coin shape taken out of it
   // does it want to be as thick as a coin, or slightly thinner??
  linear_extrude(coinThickness){
        //difference(){
            square([length,coinDiameter],true);
        //    translate([length/2,0,0])
        //        circle(d=coinDiameter);
        //}
  }
  }
  translate ([-80,-27,5]) cube([300,11,15]);
  }
        translate([32.5,-21,5]) rotate([0,180,90]) gear_rack(mod=2.5,number_of_teeth=25,rack_width=10,rack_bottom_height=3);
}


//
//  The flange is the part that hooks a pipe to a flat piece that we can bolt
//  to the tray.  The bolt holes are in a separate module.
//

module flange(){
  h = 3.5;
 
  difference(){
     difference() {
        // the basic shape is a cube with a cylinder tacked onto it
       union(){
        cube([flangeWidth,flangeHeight,h],center=true);
        translate([0,0,8])
            //cylinder(r=26.5, h=h+10, center=true);
            cube([boxHeight+10,boxWidth+10,h+10],center=true);

       }
       // remove the hole the pipe fits in - it doesn't go all the way through, so the
       // pipe can sit on a "shelf"
       translate([0,0,h+9])
//	      cylinder(r=pipeRadius, h=h+20, center=true);
            cube([boxHeight+7,boxWidth+7,h+20],center=true);

     }
    // remove the hole the coin will fall through
     cube([boxHeight,boxWidth,h+30],center=true);
//	cylinder(r=insidePipeRadius, h=h+30, center=true);
   }
}


// The tray is a simple shape composed of a bunch of different cubes to hook everything to
//  some of the mounting holes (that hook to the flange) are in another module
module tray()
{

// Tray
 difference(){
   cube([coinDiameter+wallThickness*2,length+40,wallThickness+coinThickness],center=true);
    translate([0,+5,wallThickness/2]) cube([insidePipeRadius*2,length+50,coinThickness],center=true);
 }

// Supports that match up with flange
supportHeight = (coinThickness+wallThickness)/2-wallThickness/2;
supportWidth = 40-(coinDiameter+wallThickness*2)/2;
offset = coinDiameter/2+wallThickness+supportWidth/2;
translate([offset,length/2-20,0])cube([supportWidth,80,wallThickness+coinThickness],center=true);
translate([-(offset),length/2-20,0])cube([supportWidth,80,wallThickness+coinThickness],center=true);

// another leg to put a screw in
//translate([offset,-(length/2-10),0])cube([supportWidth,20,wallThickness+coinThickness],center=true);

// servo holder
    servoHolderLength=120-40;
 
    difference(){
     color("green") translate([-(offset+5),-(length/2-20),0])cube([supportWidth+10,servoHolderLength,   wallThickness+coinThickness],center=true);
        union(){
        color("blue") translate([-36.5-6,-25,0]) cylinder(r=screwRadius,h=20,center=true);
        color("blue") translate([-36.5-6,-124+75-25,0]) cylinder(r=screwRadius,h=20,center=true);
        }
    }

 if (False)
 difference() {

difference(){
    color("green") translate([-(offset+5),-(length/2)-20,0])cube([supportWidth+10,servoHolderLength,   wallThickness+coinThickness],center=true);
// servo hole - 40.75
    servoLength = 40.75;
    servoWidth=21.5;
    translate([-(offset+1),-(length/2+50),0])cube([servoWidth,servoLength,coinThickness+wallThickness+10],center=true);
   }
   // subtract out the base
      translate([-(offset+5),-(length/2)+20,wallThickness])cube([supportWidth+10,servoHolderLength-70,   wallThickness+coinThickness],center=true);
}
}


// this subtracts holes from the flange
module holeFlange()
{
       difference() {
          flange();
          union() {
            translate([holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20, center=true);
            translate([holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
            translate([-holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
            translate([-holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
           }
       }
}

module holeTray()
{
  //subtract the holes from the tray
  difference() {
      

    tray();
    union() {
      //servo holes
      translate([-28.5-4,-75-15,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-36.5-4,-75-15,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-28.5-4,-124-15,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-36.5-4,-124-15,0]) cylinder(r=screwRadius,h=20,center=true);

      // holes to match up with the flange
      translate([0,length/2-20,0]) union(){
       translate([holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
       translate([holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
       translate([-holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
       translate([-holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
      }
    }
    
    
    // mounting holes
      translate([-35,-60,0]) cylinder(r=screwRadius,h=20,center=true);
     // translate([31,-40,0]) cylinder(r=screwRadius,h=20,center=true);
    
  }
}

module servoHolder(
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
    translate([0,woffset,0]) cube([servo_length,servo_width, servo_mount+5],center=true);
    }
    union(){
    translate([0,-width/2+2.5,14])cube([length,5,servo_mount+20],center=true);


    }
}

module servoHolderHoles(){
    difference(){
        rotate([90,0,270]) servoHolder();
        union(){
      //translate([30-28.5-4,-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
      translate([30-36.5,-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
      translate([30-36.5-5,-15+40,-30]) cube([10,screwRadius*2,50],center=true);       
      translate([30-36.5-10,-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
     // translate([30-28.5-4,-124+75+40-15,-30]) cylinder(r=screwRadius,h=50,center=true);
      translate([30-36.5,-124+75-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
      translate([30-36.5-5,-124+75-15+40,-30]) cube([10,screwRadius*2,50],center=true);
      translate([30-36.5-10,-124+75-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
    rotate([0,90,0])translate([8,0,20])color("red") union(){
      translate([30-36.5,-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
      translate([30-36.5-6,-15+40,-30]) cube([11,screwRadius*2,50],center=true);       
      translate([30-36.5-12,-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
      translate([30-36.5,-124+75-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
      translate([30-36.5-6,-124+75-15+40,-30]) cube([11,screwRadius*2,50],center=true);       
      translate([30-36.5-12,-124+75-15+40,-30]) cylinder(r=screwRadius,h=50,center=true);
    }

        }
    }
    

    
    
}


module  dowelFlange(){
  h = 3.5;
 
  dowelRadius=6.35/2;
  dowelHolderRadius=dowelRadius+2;
    

  difference(){
     difference() {
        // the basic shape is a cube with a cylinder tacked onto it
       union(){
           difference(){
             translate([boxHeight/2+dowelHolderRadius/2,boxWidth/2+dowelHolderRadius/2,8]) cylinder(r=dowelHolderRadius, h=10, center=true);

          translate([boxHeight/2+dowelRadius/2,boxWidth/2+dowelRadius/2,8]) cylinder(r=dowelRadius, h=h+20, center=true);
           }
           difference(){
             translate([-(boxHeight/2+dowelHolderRadius/2),boxWidth/2+dowelHolderRadius/2,8]) cylinder(r=dowelHolderRadius, h=10, center=true);

          translate([-(boxHeight/2+dowelRadius/2),boxWidth/2+dowelRadius/2,8]) cylinder(r=dowelRadius, h=h+20, center=true);
           }
             dowelRadius2=8.35/2;
            dowelHolderRadius2=dowelRadius2+2;

           difference(){
             translate([boxHeight/2+dowelHolderRadius2/2,-(boxWidth/2+dowelHolderRadius2/2),8]) cylinder(r=dowelHolderRadius2, h=10, center=true);

          translate([boxHeight/2+dowelRadius2/2,-(boxWidth/2+dowelRadius2/2),8]) cylinder(r=dowelRadius2, h=h+20, center=true);
           }
           difference(){
             translate([-(boxHeight/2+dowelHolderRadius2/2),-(boxWidth/2+dowelHolderRadius2/2),8]) cylinder(r=dowelHolderRadius2, h=10, center=true);

          translate([-(boxHeight/2+dowelRadius2/2),-(boxWidth/2+dowelRadius2/2),8]) cylinder(r=dowelRadius2, h=h+20, center=true);
           }
        cube([flangeWidth,flangeHeight,h],center=true);

       }


     }
    // remove the hole the coin will fall through
     cube([boxHeight,boxWidth,h+30],center=true);
//	cylinder(r=insidePipeRadius, h=h+30, center=true);
   }
}


// this subtracts holes from the flange
module holeDowelFlange()
{
       difference() {
          dowelFlange();
          union() {
            translate([holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20, center=true);
            translate([holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
            translate([-holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
            translate([-holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
           }
       }
}

//length=150;
length = boxWidth+15.5+21;

//color("blue")  translate([200,0,0]) pusher(length);
//color("red")  translate([0,length/2-20,10])holeFlange();
//color("orange") translate([-30,-length/2-20-28,25]) servoHolderHoles();
color("orange") translate([-32,-length/2+16,25]) servoHolderHoles();
holeTray();
color("red")  translate([0,length/2-20,10])holeDowelFlange();

// todo - flange with supports for dowels
// todo - servo holder, make it taller so we can adjust on two axis - and fix problems easily - no washers needed