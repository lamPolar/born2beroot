#!/bin/bash

printf "#Architecture: "
uname -a

printf "#CPU physical : "
cat /proc/cpuinfo | grep "physical id" | uniq | wc -l

printf "#vCPU : "
cat /proc/cpuinfo | grep "processor" | wc -l

printf "#Memory Usage: "
free --mega | grep "Mem" | awk '{printf"%d/%dMB (%.2f%%)\n", $3, $2, $3/$2*100}'

printf "#Disk Usage: "
total=`df -P -BKB | grep -v 'Filesystem' | awk '{sum+=$2}END{printf sum}'`
usage=`df -P -BKB | grep -v 'Filesystem' | awk '{sum+=$3}END{printf sum}'`
echo $total $usage | awk '{printf "%d/%dGB (%d%%)\n", $2/1024, $1/(1024*1024), $2/$1*100}'

printf "#CPU load: "
mpstat | grep "all" |awk '{printf "%.2f%%\n", 100-$NF}'

printf "#Last boot: "
who -b | awk '{printf $3" "$4"\n"}'

printf "#LVM use: "
if [ $(lsblk | awk '{print $6}' | grep "lvm" | wc -l) -eq 0 ];
then echo no; else echo yes; fi

tcp=$(ss | grep -i "tcp" | wc -l)
printf "#Connections TCP : $tcp ESTABLISHED\n"

printf "#User log: "
who | wc -l

ip=$(hostname -I)
mac=$(ip a | grep "ether" | head -1 | awk '{printf $2}')
printf "#Network: IP $ip ($mac)\n"

cnt_sudo=$(journalctl | grep "sudo" | wc -l)
printf "#Sudo : $cnt_sudo cmd \n"

: <<'END'
Broadcast message from root@heeskim42 (somewhere) (Wed Jun  1 20:20:01 2022):

	 #Architecture: Linux heeskim42 5.10.0-14-amd64 #1 SMP Debian 5.10.113-1 (2022-0
	 4-29) x86_64 GNU/Linux
	 #CPU physical : 1
	 #vCPU : 12
	 #Memory Usage: 110/1021MB (10.77%)                                                   40,24         Bot
	 #Disk Usage: 1610/27GB (5%)
	 #CPU load: 0.18%
	 #Last boot: 2022-06-01 20:04
	 #LVM use: yes
	 #Connections TCP : 1 ESTABLISHED
	 #User log: 2
	 #Network: IP 10.0.2.15  (08:00:27:d9:fe:4d)
	 #Sudo : 47 cmd
END
