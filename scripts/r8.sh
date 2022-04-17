#!/bin/bash


org="https://github.com/labour-camp/links/blob/master/good3.md"
new="http://138.197.204.166:81/youtube.html"

mds=$(ls ../pages/*/*.md)

for md in $mds; do
	echo $md
	sed -i "s#$org#$new#g" $md
done




#sed -i "s#$org#$new#g" /nogfw/README.md

