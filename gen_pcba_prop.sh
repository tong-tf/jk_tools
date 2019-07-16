#!/bin/bash


if [ $# -lt 1 ]; then
	echo "Assign a path to gen "
	exit
fi
echo $1
name=$(basename $1)
echo "$name"
conf=../pcbas/${name}.prop
echo -e "JK_PCBA\tJK_PROJECT\tJK_CHOICE" > $conf   # -e 来解析\t

for pcba in $(ls $1/pcba/); do
	if [[ "$pcba" = "tools" ]]; then
		continue
	fi
    for project in $(ls $1/pcba/$pcba); do
    	if [[ "$project" = "common" ]]; then
    		continue
    	fi
    	echo "$pcba $project"
    	echo -e "$pcba\t$project\t${pcba}-${project}" >> $conf
    done
done