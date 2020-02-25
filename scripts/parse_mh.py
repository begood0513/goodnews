#!/usr/bin/python
# coding: utf-8

import macros
import sys
import os
import json
import requests
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup

sys.setrecursionlimit(2000)

channel = sys.argv[1]
json_file = channel + '.js'

index_page = '' + macros.head
links = macros.tail

with open(json_file, 'r') as load_f:
	root = json.load(load_f)


def get_content(url):
	response = requests.get(url)  # headers= {'Accept-Encoding': 'gzip'})
	text = response.text.encode('ISO-8859-1')
	parser = BeautifulSoup(text, 'html.parser')
	for link in parser.find_all('a'):
		del link['title'] 
		del link['class'] 
	content = parser.find(id='ar_bArticleContent').prettify().encode('utf-8')
	return content.replace('href="/mh/', 'href="http://www.minghui.org/mh/') \
		.replace('src="/mh/', 'src="http://www.minghui.org/mh/') \
		.replace('<a href', '<ok href').replace('</a>', '</ok>')


def write_page(f_name, f_path, title, link, content):
	new_link = macros.git_base_url + '/' + channel + '/' + f_name 
	body = '### ' + title
	body += "\n------------------------\n\n" + macros.menu + "\n\n" + content
	body += "\n<hr/>\n手机上长按并复制下列链接或二维码分享本文章：<br/>"
	body += "\n" + new_link + " <br/>"
	body += "\n<a href='" + new_link + "'><img src='" + new_link + ".png'/></a> <br/>"
	body += "\n原文地址（需翻墙访问）：" + link + "\n"
	body += "\n\n------------------------\n" + links
	fh = open(f_path, 'w')
	fh.write(body)


def get_name(link):
	if link.find('-') == -1:
		fname = link.split('/')[-1].split('.')[0]
	else:
		fname = link.split('-')[-1].split('.')[0]
		#fname = link[::-1].split('-')[0][5:][::-1]
	return fname


for child in root:
	if root.index(child) > 60:
		continue
	link = 'http://www.minghui.org' + child[3].encode('utf-8')
	title = child[1].encode('utf-8')
	#content = get_content(link)
	name = get_name(link) + '.md'
	file_path = '../pages/' + channel + '/' + name 

	if not os.path.exists(file_path):
	#if True:
		print file_path
		content = get_content(link)
		write_page(name, file_path, title, link, content)
	index_page += '#### [' + title + '](' + file_path + ') \n\n'


index_file = open('../indexes/' + channel + '.md', 'w')
index_file.write(index_page)
index_file.close()


