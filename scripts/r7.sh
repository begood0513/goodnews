#!/bin/bash


mds=$(ls ../pages/*/*.md)

for md in $mds; do
	echo $md
	sed -i "s#影子政府(Deep State) 被全世界封杀的真相 - 珍妮特.奥斯巴德纪录片#中国活摘：掩藏在器官移植业的群体灭绝#g" $md
	sed -i "s#res2/FallOfTheCabal/index.html#res/Organs/index.html#g" $md
done



#sed -i "s#$org#$new#g" /nogfw/README.md

