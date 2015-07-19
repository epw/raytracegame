#include "colors.inc"
#include "stones.inc"
#include "woods.inc"
#include "activeobjs.inc"

#include "worldstandard.inc"

background { color Black }

#ifdef (Active)
global_settings { ambient_light color rgb<.001, .001, .001> }
#end

#macro Head_Camera(X, Y)
camera {
	spherical
	angle 360
	location <X, Y, HEAD_HEIGHT>
	look_at <X, Y + 1, HEAD_HEIGHT>
	up <0, 0, 1>
	sky y
}
#end

#declare ROOM_SIZE = 15;

difference {
	box { <-100, -100, -100>, <100, 100, 100> }
	box { <-ROOM_SIZE/2, -ROOM_SIZE/2, 0>, <ROOM_SIZE/2, ROOM_SIZE/2, 4.5> }
	box { <-1.3, ROOM_SIZE/2, 0>, <1.3, ROOM_SIZE/2 + 30, 3.5> }
	texture { T_Stone1
		scale .1
	}
}

Active_Object ("box",
box { <-.5, -4, 0> <.5, -5, 1>
	texture { T_Wood4 }
})

#ifdef(Active)
#declare Passway = color rgbt<0, 0, 0, 0>;
#else
#declare Passway = color rgbt<0, 0, 0, 1>;
#end

Active_Object ("corridor",
plane { y, ROOM_SIZE / 2 + 0.1
	texture {
		pigment { Passway }
	}
})

#declare Sconce_Color = color rgb<.8, .8, .5>;

#declare Sconce_Object = sphere { <0, 0, 0>, .1
	texture {
		pigment { Sconce_Color }
	}
	finish { ambient 2 }
};


#declare Sconce =
#ifndef (Active)
light_source { <0, 0, 0> Sconce_Color
	looks_like { Sconce_Object }
};
#else
object { Sconce_Object };
#end

object { Sconce
	translate <-5, -5, 4.49>
}
object { Sconce
	translate <-5, 5, 4.49>
}
object { Sconce
	translate <5, 5, 4.49>
}
object { Sconce
	translate <5, -5, 4.49>
}

object { Sconce
	translate <1.29, ROOM_SIZE/2 + 10, 3.49>
}

fog {
	distance 10
	color rgb<0, 0, 0>
}