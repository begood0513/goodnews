#!/usr/bin/python
# coding: utf-8

import random

git_base_url = "https://github.com/begood0513/goodnews/blob/master/pages"


head = '####  [法轮功真相](../../../../basic/blob/master/README.md) &nbsp;|&nbsp; [九评共产党](../../../../9ping.md/blob/master/README.md) &nbsp;|&nbsp; [解体党文化](../../../../jtdwh.md/blob/master/README.md)  &nbsp;|&nbsp; [共产主义的终极目的](../../../../gczydzjmd.md/blob/master/README.md) &nbsp;|&nbsp; [魔鬼在统治我们的世界](../../../../mgztzwmdsj.md/blob/master/README.md) \n\n'

menu = "#### [首页](../../README.md)  &nbsp;&nbsp;|&nbsp;&nbsp; _channellink_  &nbsp;&nbsp;|&nbsp;&nbsp; [热点推荐](../../indexes/热点推荐.md)  &nbsp;&nbsp;|&nbsp;&nbsp; [法轮功真相](../../../../../basic/blob/master/README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [翻墙教程](https://github.com/gfw-breaker/guides/blob/master/README.md)\n\n"

links = "\n\n"

links += "#### [ 💌 退出中共组织，良心的选择、前途的选择](https://github.com/begood0513/goodnews/blob/master/quit/letter.md) \n\n"
links += "#### [ 🎬 《伪火》- 天安门自焚真相](http://209.250.226.216:10000/videos/blog/index.html)&nbsp; "
links += "| &nbsp;[《六月黑夜》- 六四天安门大屠杀](http://209.250.226.216:10000/videos/88/index.html)\n\n"
links += "#### [ 🎬  纪录片《红墙的记忆》（中南海万人和平上访纪实）](http://209.250.226.216:10000/videos/legend/index.html)\n\n"
links += "#### [ 🔥  禁书下载（政治、经济、人权、民主自由、文革、六四 ...）](https://github.com/gfw-breaker/books/blob/master/README.md)\n\n"
links += "#### [ 🎬  翻墙必看视频（YouTube热门频道、网站代理、时事热点、历史事件 ...）](http://209.250.226.216:81/youtube.html)\n\n"

tail = ""

def write_page(channel, f_name, f_path, title, link, content):
	clink = '[{}](../../indexes/{}.md) '.format(channel, channel)
	nmenu = menu.replace('_channellink_', clink)
	jsdelivr = 'https://cdn.jsdelivr.net/gh/begood0513/goodnews/pages/' + channel + '/' + f_name
	new_link = git_base_url + '/' + channel + '/' + f_name
	body = '### ' + title
	body += "\n------------------------\n\n" + nmenu + "\n\n" +  content
	body += "\n<hr/>\n手机上长按并复制下列链接或二维码分享本文章：<br/>"
	body += "\n" + new_link + " <br/>"
	body += "\n<a href='" + new_link + "'><img src='" + jsdelivr + ".png'/></a> <br/>"
	body += "\n原文地址（需翻墙访问）：" + link + "\n"
	body += "\n\n------------------------\n" + nmenu 
	body += "\n<img src='http://gfw-breaker.win/goodnews/" + f_path[3:] + "' width='0px' height='0px'/>"
	fh = open(f_path, 'w')
	fh.write(body)
	fh.close()


def get_links():
	result = ""
	idx_file = '/usr/share/nginx/html/videos/res1/news/readme.txt'
	site_base_url = "http://209.250.226.216:10000/videos/res1/news/"
	guide = '\n\n---\n#### [鉴于微信频繁屏蔽本项目内容，请微信用户请参考此教程绕过封锁](https://gitlab.com/lxm0604/info/-/raw/master/imgs/we.png)\n---\n\n'
	lines = open(idx_file, "r").read().splitlines()
	for line in random.sample(lines[1:13], 3):
		cols = line.split(',')
		url_path = site_base_url + cols[0] + '.html'
		title = cols[1]
		md_link = "#### [ 🔥 %s](%s)\n\n" % (title, url_path)
		result = result + md_link
	return links + result #+ guide



