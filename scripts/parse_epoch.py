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


def get_article_body(link):
	response = requests.get(link)
	text = response.text.encode('utf-8').replace('</p>\n</p>','</p>')
	parser = BeautifulSoup(text, 'html.parser')
	body = parser.find('div', id='artbody')
	try:
		for twitter in body.find_all('twitter-widget'):
			twitter.decompose()
		body.find('header').decompose()
		body.find('div', id='below_article_ad').decompose()
		body.find('aside').decompose()
		body.find('div', id='recommend_post').decompose()
	except:
		pass	
	return body.prettify().encode('utf-8')


def get_content(orgText, link):
	text = orgText.replace('</p>\n</p>','</p>')
	parser = BeautifulSoup(text, 'html.parser')
	for img in parser.find_all('img'):
		del img['width']
		del img['height']
	for iframe in parser.find_all('iframe'):
		iframe.decompose()
	for script in parser.find_all('script'):
		script.decompose()
	for a in parser.find_all('a'):
		del a['title']
		del a['class']
	content = '<div>' + parser.prettify().encode('utf-8')  + '</div>'

	# get post image
	response = requests.get(link)
	text = response.text.encode('utf-8')
	parser = BeautifulSoup(text, 'html.parser')
	post_image = parser.find('div', attrs = {'class': 'featured_image'})
	if post_image is None:
		post = ''
	else:
		img = post_image.find('noscript').find('img')
		caption = post_image.find('div', attrs = {'class': 'caption'})
		if img is None or caption is None:
			post = ''
		else:
			del img['width']
			del img['height']
			post = '<div>' + img.prettify().encode('utf-8') + \
				caption.prettify().encode('utf-8') + '</div><hr/>' + \
				macros.get_links()
				#'\n\n#### [ 💌  武汉肺炎来势凶凶， 如何自救：“不信一万就信万一”](https://github.com/begood0513/goodnews/blob/master/quit/letter.md)\n\n'

	#.replace('<a href', '<span href').replace('</a>', '</span>') \
	return (post + content ) \
		.replace('<a href', '<ok href').replace('</a>', '</ok>') \
		.replace('</figure>','</figure><br/>') \
		.replace('<figcaption','<br/><figcaption') \
		.replace('</figcaption>','</figcaption><br/>') \
		.replace('<h2>', '<h4>') \
		.replace('<h2 ', '<h4 ') \
		.replace('</h2>', '</h4>')


def get_name(link):
	fname = link.split('/')[-1]
	return fname.split('.')[0]


def keep_updating(title):
    return title.find('更新') > -1

# sync single page
if len(sys.argv) > 4:
	print sys.argv[5]
	body = get_article_body(sys.argv[5])
	content = get_content(body, sys.argv[5])
	macros.write_page(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], content)	
	sys.exit(1)


tree = ET.parse(xml_file)
root = tree.getroot()

for child in root[0]:
	if child.tag != 'item':
		continue
	link = child.find('link').text
	title = child.find('title').text.encode('utf-8')
	#content = child.find('content').text.encode('utf-8')
	#content = get_content(content)
	name = get_name(link) + '.md'
	file_path = '../pages/' + channel + '/' + name 
	
	if not os.path.exists(file_path) or keep_updating(title):
	#if True:
		print file_path
		content = child.find('content').text.encode('utf-8')
		content = get_content(content, link)
		macros.write_page(channel, name, file_path, title, link, content)
	index_page += '#### [' + title + '](' + file_path + ') \n\n'


index_file = open('../indexes/' + channel + '.md', 'w')
index_file.write(index_page)
index_file.close()

