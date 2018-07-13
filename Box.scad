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
flangeWidth = 100;
servoPusherHoleDiameter=1.75;
//
// The pusher is the part that pushes coins out. It has a handle, and hole to hook
// a wire, that is hooked to the servo horn
//


module pusher(length){

  // This is the handle on top the servo hooks to
  translate([-length/2+7.5,0,7.5+coinThickness])
    difference() {
        cube([15,5,15],center=true);
        rotate([90, 0, 0]) cylinder(r=servoPusherHoleDiameter/2,h=9,center=true);
   }   
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
            //cylinder(r=26.5, h=h+10, center=true);
            cube([boxHeight+5,boxWidth+5,h+10],center=true);

       }
       // remove the hole the pipe fits in - it doesn't go all the way through, so the
       // pipe can sit on a "shelf"
       translate([0,0,h+9])
//	      cylinder(r=pipeRadius, h=h+20, center=true);
            cube([boxHeight,boxWidth,h+20],center=true);

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
   // difference(){
 difference(){
   cube([coinDiameter+wallThickness*2,length,wallThickness+coinThickness],center=true);
   color("red") translate([0,+5,wallThickness/2]) cube([insidePipeRadius*2,length+20,coinThickness],center=true);
 }
 //translate([0,length/2,-wallThickness])cylinder(h=coinThickness,r=coinDiameter/2,center=true);
//}

supportHeight = (coinThickness+wallThickness)/2-wallThickness/2;
supportWidth = 40-(coinDiameter+wallThickness*2)/2;
offset = coinDiameter/2+wallThickness+supportWidth/2;
echo (offset);
translate([offset,length/2-20,0])cube([supportWidth,80,wallThickness+coinThickness],center=true);
translate([-(offset),length/2-20,0])cube([supportWidth,80,wallThickness+coinThickness],center=true);

// another leg to put a screw in
//translate([offset,-(length/2-10),0])cube([supportWidth,20,wallThickness+coinThickness],center=true);

// servo holder
difference(){


    servoHolderLength=180-40;
    translate([-(offset+5),-(length/2)-20,0])cube([supportWidth+10,servoHolderLength,   wallThickness+coinThickness],center=true);
// servo hole - 40.75
    servoLength = 40.75;
    servoWidth=21.5;
    translate([-(offset+1),-(length/2+50),0])cube([servoWidth,servoLength,coinThickness+wallThickness+10],center=true);
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
      translate([-28.5-4,-75,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-36.5-4,-75,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-28.5-4,-124,0]) cylinder(r=screwRadius,h=20,center=true);
      translate([-36.5-4,-124,0]) cylinder(r=screwRadius,h=20,center=true);

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
      translate([31,-40,0]) cylinder(r=screwRadius,h=20,center=true);
    
  }
}


length=150;

color("blue")  translate([200,0,0]) pusher(length);
//color("red")  translate([0,length/2-20,10])holeFlange();
//color("green")  holeTray();


