#!/usr/bin/python
# coding: utf-8

git_base_url = "https://github.com/begood0513/goodnews/blob/master/pages"

head = '####  [法轮功真相](../../../../basic/blob/master/README.md) &nbsp;|&nbsp; [九评共产党](../../../../9ping.md/blob/master/README.md) &nbsp;|&nbsp; [解体党文化](../../../../jtdwh.md/blob/master/README.md)  &nbsp;|&nbsp; [共产主义的终极目的](../../../../gczydzjmd.md/blob/master/README.md) &nbsp;|&nbsp; [魔鬼在统治我们的世界](../../../../mgztzwmdsj.md/blob/master/README.md) \n\n'
#'#### [💌武汉肺炎来势凶凶， 我要抛弃中共邪党保命](https://github.com/begood0513/goodnews/blob/master/quit/letter.md)\n\n'

menu = "#### [首页](../../README.md)  &nbsp;&nbsp;|&nbsp;&nbsp; _channellink_  &nbsp;&nbsp;|&nbsp;&nbsp; [热点推荐](../../indexes/热点推荐.md)  &nbsp;&nbsp;|&nbsp;&nbsp; [法轮功真相](../../../../../basic/blob/master/README.md)\n\n"

tail = ""

def write_page(channel, f_name, f_path, title, link, content):
	clink = '[{}](../../indexes/{}.md) '.format(channel, channel)
	nmenu = menu.replace('_channellink_', clink)
	new_link = git_base_url + '/' + channel + '/' + f_name
	body = '### ' + title
	body += "\n------------------------\n\n" + nmenu + "\n\n" +  content
	body += "\n<hr/>\n手机上长按并复制下列链接或二维码分享本文章：<br/>"
	body += "\n" + new_link + " <br/>"
	body += "\n<a href='" + new_link + "'><img src='" + new_link + ".png'/></a> <br/>"
	body += "\n原文地址（需翻墙访问）：" + link + "\n"
	body += "\n\n------------------------\n" + nmenu 
	body += "\n<img src='http://gfw-breaker.win/goodnews/" + f_path[3:] + "' width='0px' height='0px'/>"
	fh = open(f_path, 'w')
	fh.write(body)
	fh.close()

