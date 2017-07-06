/*
   Copyright 2017 Alan Steremberg
*/
// configuration

$fn=100;

coinDiameter = 38.6;
coinThickness= 3.9;
pipeRadius = 24.25;
insidePipeRadius=20;
wallThickness = 2.5;
screwDiameter = 4.8;
screwRadius=screwDiameter/2;
holeOffset = 35;
flangeWidth = 80;

//
// The pusher is the part that pushes coins out. It has a handle, and hole to hook
// a wire, that is hooked to the servo horn
//


module pusher(length){

  // This is the handle on top the servo hooks to
  translate([-length/2+7.5,0,7.5+coinThickness])
    difference() {
        cube([15,5,15],center=true);
        rotate([90, 0, 0]) cylinder(r=2.5,h=9,center=true);
   }   
   // extrude the square minus circle into a cube with a coin shape taken out of it
   // does it want to be as thick as a coin, or slightly thinner??
  linear_extrude(coinThickness){
        difference(){
            square([length,coinDiameter],true);
            translate([length/2,0,0])
                circle(d=coinDiameter);
        }
  }
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
        cube([flangeWidth,flangeWidth,h],center=true);
        translate([0,0,8])
            cylinder(r=26.5, h=h+10, center=true);
       }
       // remove the hole the pipe fits in - it doesn't go all the way through, so the
       // pipe can sit on a "shelf"
       translate([0,0,h+9])
	      cylinder(r=pipeRadius, h=h+20, center=true);
     }
    // remove the hole the coin will fall through
	cylinder(r=insidePipeRadius, h=h+30, center=true);
   }
}


// The tray is a simple shape composed of a bunch of different cubes to hook everything to
//  some of the mounting holes (that hook to the flange) are in another module
module tray()
{
    
   // this is the main tray that mates with the pusher. 
   // It is the groove the pusher sits in. 
   difference(){
      cube([coinDiameter+wallThickness*2,length,wallThickness+coinThickness],center=true);
      translate([0,+5,wallThickness/2]) cube([insidePipeRadius*2,length+20,coinThickness],center=true);
   }


   // some variables to make things easier
   supportHeight = (coinThickness+wallThickness)/2-wallThickness/2;
   supportWidth = flangeWidth/2-(coinDiameter+wallThickness*2)/2;
   offset = coinDiameter/2+wallThickness+supportWidth/2;


   // This creates the area for the flange too hook to. It is the same size as the flange.
   translate([offset,length/2-20,0])cube([supportWidth,flangeWidth,wallThickness+coinThickness],center=true);
   translate([-(offset),length/2-20,0])cube([supportWidth,flangeWidth,wallThickness+coinThickness],center=true);


   // servo holder
   difference(){
    servoHolderLength=160;
    translate([-(offset+5),-(length/2),0])cube([supportWidth+10,servoHolderLength,   wallThickness+coinThickness],center=true);
// servo hole - 40.75
    servoLength = 40.75;
    servoWidth=21.5;
    translate([-(offset+1),-(length/2+50),0])cube([servoWidth,servoLength,10],center=true);
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
      translate([-28.5,-75,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-36.5,-75,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-28.5,-124,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-36.5,-124,0]) cylinder(r=screwRadius,h=20,center=true);

      // holes to match up with the flange
      translate([0,length/2-20,0]) union(){
       translate([holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
       translate([holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
       translate([-holeOffset,-holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
       translate([-holeOffset,holeOffset,0]) cylinder(r=screwRadius,h=20,center=true);
      }
    }
  }
}


length=100;

color("blue")
  translate([100,0,0]) pusher(length);
  translate([0,length/2-20,5])holeFlange();
  holeTray();


