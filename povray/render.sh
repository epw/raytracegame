#! /bin/bash

POVRAY=povray

base=$1
shift

if [ $# -gt 1 ]
then
    name=$1
    shift
else
    name=$base
fi

declarations=
for arg in $*
do
    declarations="$declarations Declare=$arg"
done
root=../raytracegame
$POVRAY $base.ini $declarations
mkdir $root/places/$name
mkdir $root/masks/$name
cp $base.png $root/places/$name/rendered.png
for i in $(seq `cat activecount.txt`)
do
    $POVRAY $base.ini[Active] $declarations Declare=Active=$i \
	-O${base}_active$i.png
    cp ${base}_active$i.png $root/masks/$name/active$i.png
done
