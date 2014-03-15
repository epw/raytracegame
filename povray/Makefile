CFLAGS =

GZIP = 1

all:

Room_N: Room_N.pov
	povray $(CFLAGS) Room_N.ini
	$(foreach i,$(shell seq `cat activecount.txt`), \
		povray $(CFLAGS) Room_N.ini[Active] Declare=Active=$i \
			-ORoom_N_active$i.ppm; gzip -f Room_N_active$i.ppm; )
