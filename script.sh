#!/bin/sh

welcomeMsg="\033[1mTJYFZ console toys\033[0m\n\033[33m我们不用很麻烦很累就可以上平台\n     \033[0mPresented by Chienius\n     (c) 2013 chienius.com \n"

if [ $# -lt 1 ]; then
	echo  -e $welcomeMsg
	echo USAGE: $0 command [...]
	exit
fi


if [ $1 = "login" ]; then
	echo -e $welcomeMsg
	sep="============================\n"
	echo -e $sep"Login \n"$sep
	read -p "Enter your UserID: " user 
	stty -echo
	read -p "Enter Password: " pass
	stty echo

	loginrev=`curl http://www.tjyfz1.edu.sh.cn/chsr1.asp -d "userid=$user&pwd=$pass&leibie=xuesheng" -c cookie.txt --stderr /dev/null | iconv -f gbk -t utf-8 | grep "用户或密码错误"`

	if [ -n "$loginrev" ]; then 
		echo -e "\nIncorrect password! Try again!"
	else
		echo -e "\nLogin succeeded!"
		sed -i 's/1386345600/0/' cookie.txt
	fi

elif [ $1 = "homework" ]; then
	if [ $# = 2 ]; then
		date=$2
	else
		date=`date +%G-%m-%d`
	fi
	date -d $date +%B%d日，%A
	echo 
	hwContent=`curl http://www.tjyfz1.edu.sh.cn/cjcx/jiaoshi/plshuru/zybz/zybz.asp?rq=$date -b cookie.txt --stderr /dev/null | iconv -f gbk -t utf-8 | tr -d "\r\n"`
	hwContent=${hwContent#*body>}		#delete useless prefix
	hwContent=${hwContent%<script*}		#delete useless suffix
	hwContent=${hwContent##*listtable\">}
	echo $hwContent | sed "s/<\/table>.*$//g;s/<\/th>/\n/g;s/<\/P>/\n/g;s/<\/SPAN>/\n/g;s/<\/td> <\/tr> <tr> /\n/g;s/ <\/tr> <tr> //g;s/\w> <\w//g;s/<.[^>]*>//g;s/\n\s*$//g"	#really like a mess. I'd rewrite it the other day. 

else
	echo No such command!
	exit 0
fi
