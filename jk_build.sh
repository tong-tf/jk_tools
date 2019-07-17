#!/bin/bash
echo "Welcome to JENKINS compile system"
if [ $# -ne 3 ]; then
	echo "Bad Value, need 3 args"
	exit 1
fi

tag="$2-$3-$(date +%Y%m%d%H%M)"
echo "Build Info: $1 $2 $3, tag it : $tag"
git tag $tag
#rm -rf out;
. build/envsetup.sh
lunch  $1 $2 $3
if [[ $1 =~ rk ]]; then
	echo "RK build, use special command"
	mall && mup
else
	echo "MTK or other build, just make only"
	make -j16
    $(dirname $0)/mtk_pack
fi
if [ $? -eq 0 ]; then
	echo "Build Finish ^_^"
else
	echo "Build Fail @_@"
fi
