#! /bin/bash

# A Makefile could probably do this but since the other one is a script,
# I'm making this one one as well.

cat /dev/null > map.dat

root=../raytracegame
rm -rf $root/places $root/masks
mkdir $root/places $root/masks

render.sh First_Room
render.sh First_Room First_Room_Opened Door_Open=1
render.sh Corridor
render.sh Corridor Corridor_Opened Door_Open=1
render.sh Second_Room
