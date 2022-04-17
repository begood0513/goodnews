#!/bin/bash

channel=recommended
index=../indexes/$channel.md
csv=../indexes/ABC.csv


mkdir -p ../pages/$channel
echo > $index

head -n 300 $csv > t.csv

while read line; do
	url=$(echo $line | cut -d',' -f1)
	title=$(echo $line | cut -d',' -f2)
	name=$(basename $url | cut -d '.' -f1).md
	path=../pages/$channel/$name
	if [ ! -f $path ]; then
		if [[ $url =~ 'ntdtv.com' ]]; then
			python parse_ntdtv.py $channel $name $path "$title" $url
		elif [[ $url =~ 'epochtimes' ]]; then
			python parse_epoch.py $channel $name $path "$title" $url
		elif [[ $url =~ 'secretchina' ]]; then
			python parse_sc.py $channel $name $path "$title" $url
		elif [[ $url =~ 'github.com' ]]; then
			wget "$url?raw=true" -O $path
		elif [[ $url == /* ]]; then
			echo $title
		else
			echo 'invalid item'
		fi
	fi
	echo -e "#### [$title]($path)\n" >> $index
done < t.csv

sed -i '300,$d' $index

