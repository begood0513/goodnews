#!/bin/bash

org=$1
new=$2

mds=$(ls ../pages/*/*.md)

for md in $mds; do
	echo $md
	sed -i "s#$org:10080#$new:10080#g" $md
	sed -i "s#$org:8808#$new:8808#g" $md
	sed -i "s#$org:11000#$new:11000#g" $md
	sed -i "s#$org/youtube#$new/youtube#g" $md
done




#sed -i "s#$org#$new#g" /nogfw/README.md

