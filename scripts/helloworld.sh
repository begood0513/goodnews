#!/bin/bash

newip=136.244.71.35

ip=$(cat macros.py | grep "site_base_url =" | awk -F'/' '{print $3}' | cut -d':' -f1)

#echo $ip $newip
#exit

./rep-soh.sh $ip $newip

