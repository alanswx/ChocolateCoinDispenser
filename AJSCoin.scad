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

module flange(){
    h = 3.5;
 
difference(){
   difference() {
    union(){
    cube([60,60,h],center=true);
    translate([0,0,8])
    cylinder(r=26.5, h=h+10, center=true);
    }
    translate([0,0,h+9])
	cylinder(r=24.25, h=h+20, center=true);
   }
	cylinder(r=20, h=h+30, center=true);
}
}


module tray()
{
    difference(){
 difference(){
   cube([coinDiameter+wallThickness*2,length,wallThickness+coinThickness],center=true);
   color("red") translate([0,+5,wallThickness/2]) cube([coinDiameter,length+20,coinThickness],center=true);
 }
 translate([0,length/2,-wallThickness])cylinder(h=coinThickness,r=coinDiameter/2,center=true);
}

supportHeight = (coinThickness+wallThickness)/2-wallThickness/2;
translate([coinDiameter/2+wallThickness+5,length/2-15,supportHeight])cube([10,30,wallThickness],center=true);
translate([-(coinDiameter/2+wallThickness+5),length/2-15,supportHeight])cube([10,30,wallThickness],center=true);
translate([coinDiameter/2+wallThickness+5,-(length/2-5),supportHeight])cube([10,10,wallThickness],center=true);
translate([-(coinDiameter/2+wallThickness+5),-(length/2-5),supportHeight])cube([10,10,wallThickness],center=true);


}

length=100;
color("blue")
//   pusher(length);
//   flange();
tray();
