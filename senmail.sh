#!/bin/bash

#FILE=/etc/zabbix/alertscripts/mailtmp.txt
#echo "$3" > $FILE
#dos2unix -k $FILE
#/bin/mail -s "$2" $1 < $FILE

export LANG=en_US.UTF-8
to=$1
subject=$2
echo "$3" > /etc/zabbix/alertscripts/mailtmp.txt$$
 
dos2unix /etc/zabbix/alertscripts/mailtmp.txt$$
mail -s "$subject" "$to" < /etc/zabbix/alertscripts/mailtmp.txt$$
rm -f /etc/zabbix/alertscripts/mailtmp.txt$$
