#! /bin/bash

CFLAGS=

base=$1
root=../raytracegame
povray $CFLAGS $base.ini
mkdir $root/places/$base
mkdir $root/masks/$base
cp $base.png $root/places/$base/rendered.png
for i in $(seq `cat activecount.txt`)
do
    povray $CFLAGS $base.ini[Active] Declare=Active=$i -O$base_active$i.png
    cp $base_active$i.png $root/masks/$base/active$i.png
done
