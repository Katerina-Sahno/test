#!/bin/bash

function all {

net=$(ip a  | grep "inet " | awk '{if($0~/enp0s3/) {match($0, /([0-9]{1,3}[\.]){3}[0-9]{1,3}.[0-9]{1,2}/); print substr($0, RSTART, RLENGTH)}}')
ipAddr=$(echo $net | awk -F "/" '{print $1}' | awk 'match($0, /([0-9]{1,3}[\.]){3}/) {print substr($0, RSTART, RLENGTH)}')
mask=$(echo $net | awk -F "/" '{print $2}')
echo "$ipAddr"0/"$mask"
nmap -sP -n $(echo "$ipAddr"0/"$mask") |  awk '{if($NF~/([0-9]{3}.){2}[0-9]/){ip=$NF}} match($0, /\:[0-9A-Z]{2}.\(.+\)/) {print ip, substr($0, RSTART+4, RLENGTH-2)}'
}

function target {

nmap -sT "*" $change
}

function help {
echo -e  \
"Keyes for script: \n" \
"--all \n" \
" This key is printing ip-address and symbolic hostname from scaning all network \n" \
"--target=X.X.X.X \n" \
"This key is printing open port list on host X.X.X.X\n" \
"X.X.X.X - ip address of the scanned host\n"
}

if [ -n "$1" ]
then
	if [ $1 == "--all" ] 
	then
	  all
	else	target=$(echo $1 | awk 'match($0, /--target/) {print  substr($0, RSTART, RLENGTH)}')
		change=$(echo $1 | awk '{if($0~target) match($0, /([0-9]{1,3}[\.]){3}[0-9]{1,3}/)}{print  substr($0, RSTART, RLENGTH)}')
		if [ "--target" == "$target" ]
		then		  
		 target $change
		else help
		fi
	fi
else help
fi
