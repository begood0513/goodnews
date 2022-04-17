#!/bin/bash

org=$1
new=$2

mds=$(ls ../pages/*/*.md)

for md in $mds; do
	echo $md
	sed -i "s#nsc424/n12042989.md#recommended/406691.md#" $md
done




