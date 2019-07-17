#!/bin/bash


if [ $# -lt 1 ]; then
	echo "Assign a path to gen "
	exit
fi
echo $1
name=$(basename $1)
echo "$name"
conf=../pcbas/${name}.prop
# echo -e "JK_PCBA\tJK_PROJECT\tJK_CHOICE" > $conf   # -e 来解析\t

# for pcba in $(ls $1/pcba/); do
# 	if [[ "$pcba" = "tools" ]]; then
# 		continue
# 	fi
#     for project in $(ls $1/pcba/$pcba); do
#     	if [[ "$project" = "common" ]]; then
#     		continue
#     	fi
#     	echo "$pcba $project"
#     	echo -e "$pcba\t$project\t${pcba}-${project}" >> $conf
#     done
# done

 echo -e "JK_MTK\tJK_FLAVOR\tJK_PCBA\tJK_PROJECT\tJK_CHOICE" > $conf   # -e 来解析\t

 for mtk in $(ls $1/device/mediateksample/); do
    if [ ! -d $1/device/mediateksample/$mtk/pcba/ ]; then
        continue
    fi
    for flavor in user userdebug eng ; do
        for pcba in $(ls $1/device/mediateksample/$mtk/pcba/); do
            if [ ! -d $1/device/mediateksample/$mtk/pcba/$pcba ]; then
                continue
            fi
            for project in $(ls $1/device/mediateksample/$mtk/pcba/$pcba); do
                if [[ $project = "common" ]]; then
                    continue
                fi
                echo -e "${mtk}\t${flavor}\t${pcba}\t${project}\t${mtk}-${flavor}|${pcba}|${project}" >> $conf
            done
        done
    done
 done

