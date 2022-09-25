#!/bin/bash
# author: gfw-breaker

folder=$(dirname $0)
echo $folder
cd $folder

## pull
mkdir -p ../indexes
mkdir -p ../pages
rm *xml*
git pull

sed -i '/^$/d' ../indexes/ABC.csv

## sync
for sf in $(ls sync_*.sh); do
	bash $sf
done


## remove video news
tt=$(date "+%m%d%H%M")
for f in $(ls ../indexes/*); do
	sed -i "s/\.md)/\.md?t=$tt)/g" $f
	sed -i "/翻墙必看】/d" $f
	sed -i "/精彩推荐/d" $f
	sed -i "/全球新闻/d" $f
	sed -i "/环球直击/d" $f
	sed -i "/【中国禁闻/d" $f
	sed -i "/石涛聚焦/d" $f
	sed -i "/视频）/d" $f
	sed -i "/视频)/d" $f
done


## add qr code
base_url="https://github.com/begood0513/goodnews/blob/master"
for d in $(ls ../pages/); do
	c_name=$(grep "$d," ../indexes/names.csv | cut -d',' -f2)
	cs_name=$(echo $c_name | cut -c2-)
    for f in $(ls -t ../pages/$d | grep 'md$' | head -n 120); do
		a_path="../pages/$d/$f"
		a_url="$base_url/pages/$d/$f"
		a_name=$(echo $f | cut -d'.' -f1)
		if [ ! -f $a_path.png ]; then
			qrencode -o $a_path.png -s 4 $a_url
			sed -i "s/$d.md/$c_name.md/" $a_path
			sed -i "s/\[$d\]/[$cs_name]/" $a_path
			sed -i "s/html)/html?$a_name)/g" $a_path
			sed -i "s/.md)/.md?$a_name)/g" $a_path
		fi
    done
done


## geneate indexes
while read line; do
	key=$(echo $line | cut -d',' -f1)
	name=$(echo $line | cut -d',' -f2)
	sed -n '1,6p' ../indexes/$key.md > tmp.md
	echo "#### [油管热门频道 翻墙必看视频 新闻](http://136.244.67.144:81/youtube.html?$tt)" >> tmp.md
	sed -n '6,$p' ../indexes/$key.md >> tmp.md
	echo "<img src='http://gfw-breaker.win/goodnews/indexes/$key.md' width='0px' height='0px'/>" >> tmp.md
	mv tmp.md ../indexes/$name.md
done < ../indexes/names.csv


## hotnews
hot_page=../indexes/热点推荐.md
echo > $hot_page
while read line; do
	link=$(echo $line | cut -d',' -f1)
	fp=$(echo $link | sed 's#/goodnews/blob/master#..#g')
	title=$(echo $line | cut -d',' -f2)
	echo -e "#### [$title](https://github.com/begood0513$link?$tt)" >> $hot_page
	touch $fp
	#echo $fp
done < /root/page_count/goodnews.hot

sed -n '1,4p' $hot_page > tmp.md
echo "#### [油管热门频道 翻墙必看视频 新闻](http://136.244.67.144:81/youtube.html?$tt)" >> tmp.md
sed -n '5,$p' $hot_page >> tmp.md
mv tmp.md $hot_page

## add to git
git add ../indexes/*
git add ../pages/*


## purge old entries
for d in $(ls ../pages/); do
    for f in $(ls -t ../pages/$d/*.md | sed -n '600,$p'); do
        git rm $f  
        git rm $f.png
    done
done



## write README.md
#salvation=$(curl -s 'https://ogate.org/oo.aspx?ob=or&op=geturl&key=ehamjpcpbruwzomg&from=goodnews&count=1&ag=ogQuit.aspx')
salvation='quit/letter.md'
rm *.xml
a1=$(cat ../indexes/recommended.md | sed -n 2p | cut -c 5- | sed 's/\.\.//')
a2=$(cat ../indexes/recommended.md | sed -n 4p | cut -c 5- | sed 's/\.\.//')
a3=$(cat ../indexes/recommended.md | sed -n 6p | cut -c 5- | sed 's/\.\.//')
a4=$(cat ../indexes/recommended.md | sed -n 8p | cut -c 5- | sed 's/\.\.//')
a5=$(cat ../indexes/recommended.md | sed -n 10p | cut -c 5- | sed 's/\.\.//')
a6=$(cat ../indexes/recommended.md | sed -n 12p | cut -c 5- | sed 's/\.\.//')
a7=$(cat ../indexes/recommended.md | sed -n 14p | cut -c 5- | sed 's/\.\.//')
a8=$(cat ../indexes/recommended.md | sed -n 16p | cut -c 5- | sed 's/\.\.//')
a9=$(cat ../indexes/recommended.md | sed -n 18p | cut -c 5- | sed 's/\.\.//')
a0=$(cat ../indexes/recommended.md | sed -n 20p | cut -c 5- | sed 's/\.\.//')
aa=$(cat ../indexes/recommended.md | sed -n 22p | cut -c 5- | sed 's/\.\.//')
ab=$(cat ../indexes/recommended.md | sed -n 24p | cut -c 5- | sed 's/\.\.//')
ac=$(cat ../indexes/recommended.md | sed -n 26p | cut -c 5- | sed 's/\.\.//')
ad=$(cat ../indexes/recommended.md | sed -n 28p | cut -c 5- | sed 's/\.\.//')

cat ../quit/template.md > temp.md
sed -i "s#recomm1#$a1#g" temp.md
sed -i "s#recomm2#$a2#g" temp.md
sed -i "s#recomm3#$a3#g" temp.md
sed -i "s#recomm4#$a4#g" temp.md
sed -i "s#recomm5#$a5#g" temp.md
sed -i "s#recomm6#$a6#g" temp.md
sed -i "s#recomm7#$a7#g" temp.md
sed -i "s#recomm8#$a8#g" temp.md
sed -i "s#recomm9#$a9#g" temp.md
sed -i "s#recomm0#$a0#g" temp.md
sed -i "s#recomma#$aa#g" temp.md
sed -i "s#recommb#$ab#g" temp.md
sed -i "s#recommc#$ac#g" temp.md
sed -i "s#recommd#$ad#g" temp.md
sed "s/\.md?t=[0-9]*)/.md?t=$tt)/g" temp.md  > README.md
cp README.md ../README.md
git add ../README.md

# local
./helloworld.sh

# commit 
ts=$(date "+-%m月-%d日-%H时-%M分" | sed 's/-0//g' | sed 's/-//g')
git commit -a -m "同步于: $ts"
git push


