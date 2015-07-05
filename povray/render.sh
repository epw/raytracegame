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
if [[ -d $root/places/$name ]]; then
    rm -rf $root/places/$name
fi
mkdir $root/places/$name

if [[ -d $root/masks/$name ]]; then
    rm -rf $root/masks/$name
fi
mkdir $root/masks/$name

cp $base.png $root/places/$name/rendered.png
i=1
for a in `cat current.dat`
do
    $POVRAY $base.ini[Active] $declarations Declare=Active=$i \
	-O${base}_active_$a.png
    echo cp ${base}_active_$a.png $root/masks/$name/active_$a.png
    cp ${base}_active_$a.png $root/masks/$name/active_$a.png
    i=`expr $i + 1`
done
