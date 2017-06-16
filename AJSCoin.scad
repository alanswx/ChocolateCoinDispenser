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

module pusher(length){
  translate([-length/2+7.5,0,-7.5])
    difference() {
        cube([15,5,15],center=true);
        rotate([90, 0, 0])
        cylinder(r=2.5,h=9,center=true);
   }   
   // does it want to be as thick as a coin, or slightly thinner??
  linear_extrude(coinThickness){
        difference(){
            square([length,coinDiameter],true);
            translate([length/2,0,0])
                circle(d=coinDiameter);
        }
  }
}

module flange(){
    h = 3.5;
 
difference(){
   difference() {
    union(){
    cube([80,80,h],center=true);
    translate([0,0,8])
    cylinder(r=26.5, h=h+10, center=true);
    }
    translate([0,0,h+9])
	cylinder(r=pipeRadius, h=h+20, center=true);
   }
	cylinder(r=insidePipeRadius, h=h+30, center=true);
}
}


module tray()
{
    difference(){
 difference(){
   cube([coinDiameter+wallThickness*2,length,wallThickness+coinThickness],center=true);
   color("red") translate([0,+5,wallThickness/2]) cube([insidePipeRadius*2,length+20,coinThickness],center=true);
 }
 translate([0,length/2,-wallThickness])cylinder(h=coinThickness,r=coinDiameter/2,center=true);
}

supportHeight = (coinThickness+wallThickness)/2-wallThickness/2;
supportWidth = 40-(coinDiameter+wallThickness*2)/2;
offset = coinDiameter/2+wallThickness+supportWidth/2;
echo (supportWidth);
translate([offset,length/2-10,supportHeight])cube([supportWidth,80,wallThickness],center=true);
translate([-(offset),length/2-10,supportHeight])cube([supportWidth,80,wallThickness],center=true);


translate([offset,-(length/2-5),supportHeight])cube([supportWidth,10,wallThickness],center=true);

// servo holder
difference(){
translate([-(offset+5),-(length/2+35),supportHeight])cube([supportWidth+10,90,wallThickness],center=true);
// servo hole - 40.75
servoLength = 40.75;
servoWidth=21.5;
translate([-(offset+1),-(length/2+50),supportHeight])cube([servoWidth,servoLength,10],center=true);
}
}

length=100;
//color("blue")
//  translate([100,0,0]) pusher(length);
  //translate([0,length/2-10,5])flange();
  tray();
