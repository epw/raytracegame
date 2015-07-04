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

cat /dev/null > current.dat
echo $name >> map.dat
$POVRAY $base.ini $declarations
if [[ ! -d $root/places/$name ]]; then
    mkdir $root/places/$name
fi
if [[ ! -d $root/masks/$name ]]; then
    mkdir $root/masks/$name
fi
cp $base.png $root/places/$name/rendered.png
i=1
for a in `cat current.dat`
do
    $POVRAY $base.ini[Active] $declarations Declare=Active=$i \
	-O${base}_active$a.png
    cp ${base}_active$a.png $root/masks/$name/active$a.png
    i=`expr $i + 1`
done
