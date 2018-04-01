#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:
B=$(tput bold)
N=$(tput sgr0)

DIR=$(echo $0 | sed -r 's/task4_1.sh//g')
if [[ ${DIR:0:2} == *./* ]];then
        DIR=$( echo "$DIR" | sed -r 's/\.\///g')
        PATH_TO="$PWD/$DIR"
else
        cd $(dirname $0)
        PATH_TO=$(echo "$PWD/")
        cd - >> /dev/null
fi
exec 1>"$PATH_TO""task4_1.out"

#hardware module
	  echo '--- Hardware ---'
	#CPU
  	  echo "${B}CPU:${N} $(dmidecode -s  processor-version | awk '(NR == 1)')"
	#RAM
  	  echo "${B}RAM:${N} $(free -h | awk 'FNR==2 {print$2}')"
	#Motherboard
  	  MB=$(dmidecode -s baseboard-product-name)
  	  if [[ $MB == 0 ]];then
 	  	unset  MB
  	  fi
  	  echo "${B}Motherboard:${N} ${MB:-Unknown}"
	#System Serial Number
  	  SN=$(dmidecode -s  system-serial-number)
  	  if [[ $SN == 0 ]];then
          	unset  MB
  	  fi
  	  echo "${B}System Serial Number:${N} ${SN:-Unknown}"

#system module
  	  echo "--- System ---"
	#OS Distribution
	  echo "${B}OS Distribution:${N} $(lsb_release -d | awk -F: '{print $2}' | sed -r 's/^\s+//g')"
	#Kernel version
    	  echo "${B}Kernel version:${N} $(uname -r)"
	#Installation date
  	  ID=($(LANG=en_US ls -clt /etc | tail -n 1 | awk '{print $6,$7,$8}'))
  	  if [[ ${ID[2]} == *:* ]];then
       		echo "${B}Installation date:${N} ${ID[0]} ${ID[1]} $(LANG=en_US date | awk '{print$6}')"
  	  else echo "${B}Installation date:${N} ${ID[0]} ${ID[1]} ${ID[2]}"
  	  fi
	#Hostname
  	  echo "${B}Hostname:${N} $(hostname)"
	#Uptime
  	  echo "${B}Uptime:${N} $(uptime -p | sed 's/up //g')"
	#Processes running
  	  echo "${B}Processes running:${N} $(ps -e h | wc -l)"
	#User logged in
  	  echo "${B}User logged in:${N} $(w -h | wc -l)"

#network module
  	echo '--- Network ---'
	#Interfaces
  	  NO=$(ip -br a | awk '{print$1}' | wc -l)
  	  for ((i=1; i <= $NO; i++))
  	  do
	  	unset IPA
	  	j=3
	  	CO=$(ip -br a | awk 'FNR=='$i'{print$1}')
	  	IP=$(ip -br a | awk ' FNR=='$i'{print$'$j'}')
	  		if [[ ${#IP} != 0 && $IP != *:* ]];then
				while [[ ${#IP} != 0 && $IP != *:* ]]
			  	do
			  		IPA="$IPA $IP,"
			  		j=$(($j+1))
			  		IP=$(ip -br a | awk 'FNR=='$i'{print$'$j'}')
			  	done
   				echo "${B}$CO:${N}$IPA" | sed -r 's/,$//g'
			else
		 		echo "${B}$CO:${N} -"
  	 		fi
	  done
