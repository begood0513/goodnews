#!/bin/bash
# author: gfw-breaker


channelMap="soh_rdzz:新闻评论/热点追踪
soh_mjtss:名家谈时事
soh_grpl:新闻评论/个人评论
soh_xcjm:红朝解密
soh_whxg:古今文化/文化寻根
soh_zgxw:中国新闻
soh_gtxw:新闻评论/港台新闻及其他"

## get feeds files
for entry in $channelMap ; do
	channel=$(echo $entry | cut -d':' -f1)
	category=$(echo $entry | cut -d':' -f2)
	mkdir -p ../pages/$channel
	url="http://www.soundofhope.org/gb/category/$category"
	echo "getting channel: $url"
	python parse_soh.py $channel "$url"
done


