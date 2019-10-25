#!/bin/bash
echo "Welcome to JENKINS compile system"
#rm -rf out;
. build/envsetup.sh
lunch  $1
rm -rf out/target/product/tb8176p1_64_bsp/obj/ETC/system_build_prop_intermediates/
echo "MTK or other build, just make only"
make installclean;
make -j24
if [ $? -eq 0 ]; then
	echo "Build Finish ^_^"
else
	echo "Build Fail @_@"
fi
if [ -n "$2" ]; then
	echo "Build OTA start"
	make otapackage -j24
fi
if [ $? -eq 0 ]; then
	echo "Build OTA Finish ^_^"
	$(dirname $0)/mtk_pack OTA

else
	echo "Build Fail @_@"
fi




