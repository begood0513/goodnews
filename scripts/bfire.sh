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
done


## add qr code
base_url="https://github.com/begood0513/goodnews/blob/master"
for d in $(ls ../pages/); do
	c_name=$(grep "$d," ../indexes/names.csv | cut -d',' -f2)
	cs_name=$(echo $c_name | cut -c2-)
    for f in $(ls -t ../pages/$d | grep 'md$'); do
		a_path="../pages/$d/$f"
		a_url="$base_url/pages/$d/$f"
		if [ ! -f $a_path.png ]; then
			qrencode -o $a_path.png -s 4 $a_url
			sed -i "s/$d.md/$c_name.md/" $a_path
			sed -i "s/\[$d\]/[$cs_name]/" $a_path
		fi
    done
done


## geneate indexes
while read line; do
	key=$(echo $line | cut -d',' -f1)
	name=$(echo $line | cut -d',' -f2)
	head -n 8 ../indexes/$key.md > tmp.md
	cat links.txt >> tmp.md
	sed -n '9,$p' ../indexes/$key.md >> tmp.md
	mv tmp.md ../indexes/$name.md
done < ../indexes/names.csv


## hotnews
hot_page=../indexes/热点推荐.md
echo > $hot_page
while read line; do
	link=$(echo $line | cut -d',' -f1)
	title=$(echo $line | cut -d',' -f2)
	echo -e "#### [$title](https://github.com/begood0513$link)" >> $hot_page
done < /root/page_count/goodnews.hot

## add to git
git add ../indexes/*
git add ../pages/*


## purge old entries
for d in $(ls ../pages/); do
    for f in $(ls -t ../pages/$d | grep 'md$' | sed -n '300,$p'); do
        git rm "../pages/$d/$f"   
        git rm "../pages/$d/$f.png"   
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

cat new.md > temp.md
sed -i "s#recomm1#$a1#g" temp.md
sed -i "s#recomm2#$a2#g" temp.md
sed -i "s#recomm3#$a3#g" temp.md
sed -i "s#recomm4#$a4#g" temp.md
sed -i "s#recomm5#$a5#g" temp.md
sed -i "s#recomm6#$a6#g" temp.md
sed "s/\.md?t=[0-9]*)/.md?t=$tt)/g" temp.md  > README.md
cp README.md ../README.md
git add ../README.md

ts=$(date "+-%m月-%d日-%H时-%M分" | sed 's/-0//g' | sed 's/-//g')
git commit -a -m "同步于: $ts"
git push


