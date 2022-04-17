#!/usr/bin/python
# coding: utf-8

import macros
import sys
import os
import requests
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup

channel = sys.argv[1]
xml_file = channel + '.xml'

index_page = '' + macros.head


def get_content(text, link):
	links = "\n\n---\n\n" + macros.get_links() + "\n\n<div>"
	response = requests.get(link)
	text = response.text
	parser = BeautifulSoup(text, 'html.parser')
	article = parser.find('div', attrs = {'class': 'article_right'})
	#print(article.prettify())
	for script in article.find_all('script'):
		script.decompose()
	for iframe in article.find_all('iframe'):
		iframe.decompose()
	return article.prettify().replace('<div id="SC-22">', links) \
				.replace('src="//img1.', 'src="https://img1.') \
				.replace('src="//img2.', 'src="https://img2.') \
				.replace('src="//img3.', 'src="https://img3.') \
				.replace('src="//img4.', 'src="https://img4.') \
				.replace('src="//img5.', 'src="https://img5.') \
				.replace('<h2', '<h4').replace('</h2', '</h4') \
				.replace('<strong', '<ok').replace('</strong', '</ok') \
				.replace('<a href', '<span href') \
				.replace('</a>', '</span>')


def get_name(link):
	fname = link.split('/')[-1]
	return fname.split('.')[0]


# sync single page
if len(sys.argv) > 3 :
	print(sys.argv[5])
	content = get_content(sys.argv[4], sys.argv[5])
	macros.write_page(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], content)	
	sys.exit(1)


tree = ET.parse(xml_file)
root = tree.getroot()


for child in root[0]:
	if child.tag != 'item':
		continue
	link = child.find('link').text
	title = child.find('title').text
	name = get_name(link) + '.md'
	file_path = '../pages/' + channel + '/' + name 
	
	#if True:
	if not os.path.exists(file_path):
		print(file_path)
		content = get_content(title, link)
		macros.write_page(channel, name, file_path, title, link, content)
	index_page += '#### [' + title + '](' + file_path + ') \n\n'


index_file = open('../indexes/' + channel + '.md', 'w')
index_file.write(index_page)
index_file.close()


