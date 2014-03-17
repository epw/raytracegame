#include "colors.inc"
#include "woods.inc"
#include "activeobjs.inc"

#include "worldstandard.inc"

camera {
	location <0, 0, HEAD_HEIGHT>
	look_at <0, 5, HEAD_HEIGHT>
	up <0, 0, 1>
	sky z
}

background { color rgb<0, 0, 0> }

#ifndef (Active)
light_source { <0, 0, 10> color rgb<.7, .7, .7> }
#end

plane { z, 0
	texture { P_WoodGrain1A
//		rotate 90*x
	}
}

#declare Sphere_Color = color Gray;

#ifdef (Red_Room)
#declare Sphere_Color = color Red;
#else
#ifdef (Blue_Room)
#declare Sphere_Color = color Blue;
#end
#end

#declare Interesting_Sphere =
sphere { <0, 5, 2>, 1
	texture {
		pigment {
			Sphere_Color
		}
	}
};

Active_Object (Interesting_Sphere)

Active_Object (
box { <-1, 5, 0>, <-2, 6, 1>
	texture {
		pigment { color Green }
	}
})

// AFTER ALL RENDERING DONE, EXTRA CODE HERE

Record_Active_Count ()
