/*
   Copyright 2017 Alan Steremberg
*/
// configuration
coinDiameter = 38.6;
coinThickness= 3.9;

wallThickness = 2.5;

module pusher(length){
  translate([-length/2+7.5,0,-7.5])
    difference() {
        cube([15,5,15],center=true);
        rotate([90, 0, 0])
        cylinder(r=2.5,h=9,center=true);
   }   
  linear_extrude(wallThickness){
        difference(){
            square([length,coinDiameter],true);
            translate([length/2,0,0])
                circle(d=coinDiameter);
        }
  }
}


length=100;
color("blue")
   pusher(length);

