#!/bin/bash

if [ $# -ne 2 ]; then
	echo "please specify the parameters"
	exit 1
fi

org=$1
new=$2

channels=$(ls ../pages | grep -v ^n | grep -v prog | grep -v recom)

for channel in $channels; do
	#echo $channel; continue
	mds=$(ls ../pages/$channel/*.md)
	for md in $mds; do
		echo $md
		sed -i "s#$org#$new#g" $md
	done
done


