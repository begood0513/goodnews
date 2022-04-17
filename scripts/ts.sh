#!/bin/bash


mds=$(ls ../pages/*/*.md)

for md in $mds; do
	ts=$(basename $md | cut -d'.' -f1)
	sed -i "s/\/)/\/?$ts)/g" $md
	sed -i "s/html)/html?$ts)/g" $md
	sed -i "s/.md)/.md?$ts)/g" $md
	echo $md
done



