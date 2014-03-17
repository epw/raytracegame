#include "colors.inc"
#include "woods.inc"
#include "metals.inc"
#include "activeobjs.inc"

#include "worldstandard.inc"

#declare HEADING = 0;

camera {
	location <0, 0, HEAD_HEIGHT>
	look_at <5 * sin(HEADING), 5 * cos(HEADING), HEAD_HEIGHT>
	up <0, 0, 1>
	sky z
}

#ifndef (Active)
light_source { <100, 100, 100> color rgb<.7, .7, .7> }
light_source { <-2 * sin(HEADING), -2 * cos(HEADING), HEAD_HEIGHT + 1>
color rgb<.7, .7, .7> }
#end

background { color rgb<0.53, 0.77, 1> }

plane { z, 0
	texture { T_Wood11 }
}

fog {
	distance 100
	color rgb<0.53, 0.77, 1>
}

#declare Door = box { <-0.8, 4.95, 0>, <0.8, 5.05, HEAD_HEIGHT + 0.5>
	texture { T_Wood2
		rotate 90*x
	}
};


union {
	union {
		box { <-5.01, -5.01, -1>, <5.01, -5, HEAD_HEIGHT + 1> }
		box { <-5.01, 5.01, -1>, <5.01, 5, HEAD_HEIGHT + 1> }
		box { <-5.01, -5.01, -1>, <-5, 5.01, HEAD_HEIGHT + 1> }
		box { <5.01, -5.01, -1>, <5, 5, HEAD_HEIGHT + 1> }
		box { <-5.01, -5.01, HEAD_HEIGHT + 1>,
		<5.01, 5.01, HEAD_HEIGHT + 1.01> }
		texture { T_Wood19
			rotate 90*y
			scale .1
		}
	}
	difference {
		box { <-0.85, 4.95, 0>, <0.85, 5.05, HEAD_HEIGHT + 0.5> }
		Door
		texture { T_Wood19
			rotate 90*y
			scale .1
		}
	}
	Door
}

//difference {
//	box { <-5.5, -5.5, -1.5>, <5.5, 5.5, HEAD_HEIGHT + 1.5> }
//	box { <-5, -5, -1>, <5, 5, HEAD_HEIGHT + 1> }
//	pigment {
//		color rgb<.8, .3, .5>
//	}
//	texture { T_Wood19 }
//}

// AFTER ALL RENDERING DONE, EXTRA CODE HERE

Record_Active_Count ()
