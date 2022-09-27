#!/bin/bash

#newip=95.179.192.143
#newip=129.146.189.110 
newip=136.244.67.144

ip=$(cat macros.py | grep "site_base_url =" | awk -F'/' '{print $3}' | cut -d':' -f1)

#echo $ip $newip
#exit

./rep-soh.sh $ip $newip

