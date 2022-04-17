#!/bin/bash

if [ $# -ne 2 ]; then
	echo "please specify the parameters"
	exit 1
fi

org=$1
new=$2

sed -i "s#$org#$new#g" fire.sh


#sed -i "s#$org#$new#g" /nogfw/README.md

