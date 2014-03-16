CFLAGS =

all:


Room_N: Room_N.pov
	povray $(CFLAGS) Room_N.ini
	$(foreach i,$(shell seq `cat activecount.txt`), \
		povray $(CFLAGS) Room_N.ini[Active] Declare=Active=$i \
			-ORoom_N_active$i.png; )

Room_N_red: Room_N_red.pov
	povray $(CFLAGS) Room_N_red.ini
	$(foreach i,$(shell seq `cat activecount.txt`), \
		povray $(CFLAGS) Room_N_red.ini[Active] Declare=Active=$i \
			-ORoom_N_red_active$i.png; )

Room_N_blue: Room_N_blue.pov
	povray $(CFLAGS) Room_N_blue.ini
	$(foreach i,$(shell seq `cat activecount.txt`), \
		povray $(CFLAGS) Room_N_blue.ini[Active] Declare=Active=$i \
			-ORoom_N_blue_active$i.png; )
