#! /bin/bash

# A Makefile could probably do this but since the other one is a script,
# I'm making this one one as well.

cat /dev/null > map.dat

render.sh Room_N Room_N_red Red_Room=1
render.sh Room_N Room_N_blue Blue_Room=1

