#include "Full_Scene.pov"

Head_Camera(0, ROOM_SIZE / 2 + 5)

Active_Object ("corridor",
plane { y, ROOM_SIZE / 2 + 0.1
	texture {
		pigment { color rgbt<0, 0, 0, 1> }
	}
})
