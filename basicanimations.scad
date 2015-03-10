//Basic Animations Library
//by eriqjo February, 2015

//Uses "CHILDREN" as opposed to the deprecated "CHILD" for 2014.03+ release support
//This library is to create some 1995-PowerPointesque animations to "unveil" your model
//Supports parts in the -200mm to +200mm range for X, Y, and Z without any changes to the code.

//The "steps" parameter should be the same as the value in the Animate toolbar.

//To use, simply place the animation function before the geometry to be animated.  For example:
/*
    buildup() yourBuildModuleHere();
	
		**OR**
		
	buildup(){
		children0();
		children1();
		hello there, children...........
	}
*/

module randomcolor(){
	for(i = [0:$children-1]){
		color(rands(), rands(), rands()) children(i);
	}//for
}//module random color

module flyin(startpoint = [500,-500, -500], steps = 100){
	for(i = [0:$children-1]){
		translate(startpoint - ($t + (1/steps))*startpoint){
			children(i);
		}//translate
	}//for
}//module flyin

module fadein( tone = gold){
	for(i = [0:$children-1]){
		color( tone, $t) children(i);
	}//for
}//module fadein

module fadeout( tone = gold){
	for(i = [0:$children-1]){
		color( tone, 1- $t) children(i);
	}//for
}//module fadeout

module demoshape(){
	translate([0,0,25])
		difference(){
			sphere(r = 25, $fn = 50);
			for (i = [[0,0,0], [90,0,0], [0,90,0]]){
				rotate(i){
					translate([0,0,-30])
						cylinder( h = 60, r = 15);
				} // rotate
			} // for
		} // difference
} // module demoshape

module buildup(minZ = 0, maxZ = 50, steps = 100){
	cubeHeight = maxZ - minZ;
	for(i = [0:$children-1]){
		intersection(){		
			translate([-200, -200, minZ])
				cube([400, 400, ($t + 1/steps) * cubeHeight]);
			children(i);
		}//intersection
	}//for				
} // module buildup

module buildright(minX = 0, maxX = 50, steps = 100){
	cubeLength = maxX - minX;
	for(i = [0:$children-1]){
		intersection(){	
			translate([minX, -200, -200])
				cube([($t + 1/steps) * cubeLength, 400, 400]);
			children(i);
		}//intersection
	}//for								
} // module buildright

module buildback(minY = 0, maxY = 50, steps = 100){
	cubeWidth = maxY - minY;
	for(i = [0:$children-1]){
		intersection(){
			translate([-200, minY, -200])
				cube([400, ($t + 1/steps) * cubeWidth, 400]);
			children(i);
		}//intersection
	}//for
} //module buildback

module builddiagonal(minXYZ = [-25, -25, -25], maxXYZ = [25, 25, 25], steps = 100){
	cubeDims = maxXYZ - minXYZ;
	for(i = [0:$children-1]){
		intersection(){
			translate(minXYZ){
				scale($t + 1/steps)cube(cubeDims);
			} // translate
			children(i);
		}//intersection
	}//for
}

module revolve(middleXY = [0,0], steps = 100){
	degreesPerStep = 360/steps;
	for( i = [0 : $t * steps]){
		for(j = [0:$children-1]){
			intersection(){
				linear_extrude(height = 200, center = true, convexity = 10, twist = 0)
					polygon([middleXY, [200*cos((i) * degreesPerStep), 200*sin((i) * degreesPerStep)],
						[200*cos((i + 1) * degreesPerStep), 200*sin((i + 1) * degreesPerStep)]]);
				children(j);
			}//intersection			
		}// for
	} // for
} // module revolve

module lego(minXYZ = [-25, -25, -25], maxXYZ = [25, 25, 25], cubesperaxis = 5){
	dims = (maxXYZ - minXYZ) / cubesperaxis;
	cubesperside = pow(cubesperaxis, 2);
	cubestotal = pow(cubesperaxis, 3);
	echo("<b>Set steps = <b>",cubestotal);
	var = floor(($t)*(cubestotal-1));
			
	for(step = [0:var]){
		for(i = [0: $children-1]){
			intersection(){
				translate([(step%cubesperaxis)*dims[0] + minXYZ[0],					//x
					floor((step%cubesperside)/cubesperaxis)*dims[1] + minXYZ[1],	//y
					floor(step/cubesperside)*dims[2] + minXYZ[2]])					//z
						cube([dims[0], dims[1], dims[2]]);
				children(i);	
			} // intersection
		}//for
	}//for
				
} // module lego

module squish(){
	for(i = [0:$children-1]){
		scale([1, 1, 1-$t]) children(i);
	}
}//module squish

module unsquish(steps = 100){
	for(i = [0:$children-1]){
		scale([1, 1, $t + 1/steps]) children(i);
	} // for
}//module unsquish

//********************************DEMO ZONE********************************

//buildup demos below:
//buildup(minZ = 0, maxZ = 50, steps = 100) demoshape();
//buildup(minZ = -25, maxZ = 75, steps = 100){ for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();}

//buildback demo below:
//buildback(minY = -25, maxY = 25, steps = 100) demoshape();
//buildback(minY = -25, maxY = 75, steps = 100){ for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();}

//buildright demo below:
//buildright(minX = -25, maxX = 25, steps = 100) demoshape();
//buildright(minX = -25, maxX = 75, steps = 100){ for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();}

//revolve demos below:
//revolve() demoshape();
//revolve(middleXY = [25, 25]){for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();}

//builddiagonal demo below:
//builddiagonal(minXYZ = [-25, -25, 0], maxXYZ = [25, 25, 50]) demoshape();
//builddiagonal(minXYZ = [-25, -25, 0], maxXYZ = [75, 75, 50]){ for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();};

//lego demo below.  BE SURE TO SET YOUR STEPS TO THE TOTAL NUMBER OF CUBES (echoed in module)
//lego(minXYZ = [-25, -25, 0], maxXYZ = [75, 75, 50]){ for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();}


//squish demo below:
//squish() demoshape();
//squish() { for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();}

//unsquish demo below:
//unsquish() demoshape();
//unsquish(steps = 100){ for(i = [0 , 1]) for (j = [0,1]) translate([50*i, 50*j, 0]) demoshape();}

//fade demos below:
//fadein() demoshape();
//fadeout() demoshape();

//flyin demos below:
//flyin() demoshape();

randomcolor() demoshape();

//********************************END DEMOS********************************
