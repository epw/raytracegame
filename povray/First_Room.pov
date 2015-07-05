#include "colors.inc"
#include "stones.inc"
#include "activeobjs.inc"

#include "worldstandard.inc"

#declare HEADING = 0;

camera {
	location <0, 0, HEAD_HEIGHT>
	look_at <5 * sin(HEADING), 5 * cos(HEADING), HEAD_HEIGHT>
	up <0, 0, 1>
	sky z
}

//#ifndef (Active)
//light_source { <100, 100, 100> color rgb<.7, .7, .7> }
//#end

background { color Black }

#declare ROOM_SIZE = 15;

difference {
	box { <-100, -100, -100>, <100, 100, 100> }
	box { <-ROOM_SIZE/2, -ROOM_SIZE/2, 0>, <ROOM_SIZE/2, ROOM_SIZE/2, 4.5> }
	box { <-1.3, ROOM_SIZE/2, 0>, <1.3, ROOM_SIZE/2 + 30, 3.5> }
	texture { T_Stone1
		scale .1
	}
}

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
