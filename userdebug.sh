#!/bin/bash

###### make 8176 64bit(3G DDR) command: ./userdebug.sh RA tb8176p1_64_bsp F55P new ####################


DDR=$1
PROJECT=$2
PCBA=$3

MAKEJOBS=-j16

ACTIONS=(new n r remake pl lk kernel k bootimage userdataimage systemimage recoveryimage mm mmm mma mmma droid snod otapackage cacheimage update-modem bootimage-nodeps ramdisk cacheimage vendorimage clean odmdtboimage dtboimage)
DRAMS=(RA RB RC RD RDD RE RF RG RH RI RJ RK RL RM RN RO RP RQ RR)

ROOT=$PWD


PRELOADER_DIR=$ROOT/"vendor/mediatek/proprietary/bootable/bootloader/preloader"
LK_DIR=$ROOT/"vendor/mediatek/proprietary/bootable/bootloader/lk"

PL_DCT_DIR=$PRELOADER_DIR/"custom/$PROJECT/dct/dct"
LK_DCT_DIR=$LK_DIR/"target/$PROJECT/dct/dct"
KL_DCT_DIR=$ROOT/"vendor/mediatek/proprietary/custom/$PROJECT/kernel/dct/dct"

if [ "$PROJECT" == "tb8163p3_bsp" ]
then
	echo ">>>>>>>>>>>> Build Android Go 8163 Project (1G DRAM) <<<<<<<<<<<<"
	DDR_CLK_FILE=$PRELOADER_DIR"/platform/mt8163/src/drivers/inc/pll.h"
	KERNEL_CONFIG_DIR=$ROOT/"kernel-4.9/arch/arm/configs"
	KERNEL_DTS_DIR=$ROOT/"kernel-4.9/arch/arm/boot/dts"
elif [ "$PROJECT" == "tb8163p3_64_bsp"  ]
then
	echo ">>>>>>>>>>>> Build Android 9.0 8163 Project (2G DRAM) <<<<<<<<<<<<"
	DDR_CLK_FILE=$PRELOADER_DIR"/platform/mt8163/src/drivers/inc/pll.h"
	KERNEL_CONFIG_DIR=$ROOT/"kernel-4.9/arch/arm64/configs"
	KERNEL_DTS_DIR=$ROOT/"kernel-4.9/arch/arm64/boot/dts/mediatek"
elif [ "$PROJECT" == "tb8167p3_bsp"  ]
then
	echo ">>>>>>>>>>>> Build Android Go 8167 Project (1G DRAM) <<<<<<<<<<<<"
	DDR_CLK_FILE=$PRELOADER_DIR"/platform/mt8167/src/drivers/inc/pll.h"
	KERNEL_CONFIG_DIR=$ROOT/"kernel-4.4/arch/arm/configs"
	KERNEL_DTS_DIR=$ROOT/"kernel-4.4/arch/arm/boot/dts"
elif [ "$PROJECT" == "tb8167p5_64_bsp"  ]
then
	echo ">>>>>>>>>>>> Build Android 9.0 8167 Project (2G DRAM) <<<<<<<<<<<<"
	DDR_CLK_FILE=$PRELOADER_DIR"/platform/mt8167/src/drivers/inc/pll.h"
	KERNEL_CONFIG_DIR=$ROOT/"kernel-4.4/arch/arm64/configs"
	KERNEL_DTS_DIR=$ROOT/"kernel-4.4/arch/arm64/boot/dts/mediatek"

elif [ "$PROJECT" == "tb8167p1_bsp_nand"  ]
then
	echo ">>>>>>>>>>>> Build Android 9.0 8167 Nand Project (1G DRAM) <<<<<<<<<<<<"
	DDR_CLK_FILE=$PRELOADER_DIR"/platform/mt8167/src/drivers/inc/pll.h"
	KERNEL_CONFIG_DIR=$ROOT/"kernel-4.4/arch/arm/configs"
	KERNEL_DTS_DIR=$ROOT/"kernel-4.4/arch/arm/boot/dts"

 elif [ "$PROJECT" == "tb8176p1_64_bsp"  ]
 then
	echo ">>>>>>>>>>>> Build Android 8.1 8176 Project (3G DRAM) <<<<<<<<<<<<"
	DDR_CLK_FILE=$PRELOADER_DIR"/platform/mt8173/src/drivers/inc/pll.h"
	KERNEL_CONFIG_DIR=$ROOT/"kernel-3.18/arch/arm64/configs"
	KERNEL_DTS_DIR=$ROOT/"kernel-3.18/arch/arm64/boot/dts"

fi


DDR_H_FILE=$PRELOADER_DIR"/custom/$PROJECT/inc/custom_MemoryDevice.h"
PROJECTMK=$ROOT/"device/mediateksample/$PROJECT/ProjectConfig.mk"
PL_MAKEFILE=$PRELOADER_DIR/"custom/$PROJECT/"$PROJECT".mk"
LK_MAKEFILE=$LK_DIR/"project/"$PROJECT".mk"
KL_DBG_CFG=$KERNEL_CONFIG_DIR/""$PROJECT"_debug_defconfig"
KL_USER_CFG=$KERNEL_CONFIG_DIR/""$PROJECT"_defconfig"
KL_DTS_FILE=$KERNEL_DTS_DIR/""$PROJECT".dts"


if [ $# -lt 4 ];then
    echo "Invaild args."
    exit
fi

echo ${DRAMS[@]} | grep -wq "$DDR"
if [ $? != 0 ];then
    echo "Invaild DDR type not in (${DRAMS[@]})."
    exit
fi

if [ ! -e device/mediateksample/$PROJECT ];then
    echo "Invaild project."
    exit
fi

if [ ! -e device/mediateksample/$PROJECT/bnd/$PCBA ];then
    echo "Invaild BND_PCBA."
    exit
fi

################################ ProjectConfig.mk ####################################
if [ -e $PROJECTMK ]
then
	rm $PROJECTMK
fi
cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/ProjectConfig.mk $PROJECTMK

################################ codegen.dws #######################################
if [ -e $PL_DCT_DIR/codegen.dws ]
then
    rm $PL_DCT_DIR/codegen.dws
fi
cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/codegen.dws $PL_DCT_DIR/codegen.dws


if [ -e $LK_DCT_DIR/codegen.dws ]
then
    rm $LK_DCT_DIR/codegen.dws
fi
cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/codegen.dws $LK_DCT_DIR/codegen.dws


if [ -e $KL_DCT_DIR/codegen.dws ]
then
    rm $KL_DCT_DIR/codegen.dws
fi
cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/codegen.dws $KL_DCT_DIR/codegen.dws

##################################### makefile ########################
if [ -e $PL_MAKEFILE ]
then
    rm $PL_MAKEFILE
fi
    cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/"$PROJECT"_preloader.mk $PL_MAKEFILE

if [ -e $LK_MAKEFILE ]
then
    rm $LK_MAKEFILE
fi
    cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/"$PROJECT"_lk.mk $LK_MAKEFILE

##################################################### defconfig ###############################
if [ -e $KL_DBG_CFG ]
then
    rm $KL_DBG_CFG
fi
cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/"$PROJECT"_debug_defconfig $KL_DBG_CFG

if [ -e $KL_USER_CFG ]
then
    rm $KL_USER_CFG
fi
cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/"$PROJECT"_defconfig $KL_USER_CFG

if [ -e $KL_DTS_FILE ]
then
    rm $KL_DTS_FILE
fi
cp -rf device/mediateksample/$PROJECT/bnd/$PCBA/"$PROJECT".dts $KL_DTS_FILE
if [ "$PROJECT" == "tb8176p1_64_bsp" ]; then
	cp -f device/mediateksample/$PROJECT/bnd/$PCBA/mt8173.dtsi "$KERNEL_DTS_DIR/"
	cp -f device/mediateksample/$PROJECT/bnd/$PCBA/mt8173_plus.dtsi "$KERNEL_DTS_DIR/"
fi

##################################################### DDR ######################################

cd $PRELOADER_DIR
git checkout -- $DDR_CLK_FILE
git checkout -- $DDR_H_FILE
cd - >>/dev/null

if [ "$PROJECT" == "tb8163p3_bsp" -o  "$PROJECT" == "tb8163p3_64_bsp" ]
then
####################################### MT8163 DDR SET #########################################
if [ "$DDR" == "RA" ]
then
	echo RA1066.PCDDR3.1024.2DIE.8BIT.MT8163_DDR3_512MB_1GB_2GB
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/MT8163_DDR3_512MB_1GB_2GB/MT8163_DDR3_512MB_1GB_2GB/g" $DDR_H_FILE
elif [ "$DDR" == "RB" ]
then
	echo RB1066.PCDDR3.1024.2DIE.8BIT.COMMON_1GB_2GB_8BIT_AUTO
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/MT8163_DDR3_512MB_1GB_2GB/COMMON_1GB_2GB_8BIT_AUTO/g" $DDR_H_FILE
elif [ "$DDR" == "RC" ]
then
	echo RC1066.PCDDR3.1024.2DIE.8BIT.H5TC4G83BFA-PBA
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/MT8163_DDR3_512MB_1GB_2GB/H5TC4G83BFA-PBA/g" $DDR_H_FILE
elif [ "$DDR" == "RD" ]
then
	echo RD938.LCDDR3.1024.2DIE.32BIT.K4E8E304EE_EGCE
	sed -i "s/DDR_ANCHOR/DDR_938/g" $DDR_CLK_FILE
	sed -i "s/MT8163_DDR3_512MB_1GB_2GB/K4E8E304EE_EGCE/g" $DDR_H_FILE
elif [ "$DDR" == "RE" ]
then
	echo RE938.LCDDR3.2048.2DIE.32BIT.K4E6E304EE_EGCE
	sed -i "s/DDR_ANCHOR/DDR_938/g" $DDR_CLK_FILE
	sed -i "s/MT8163_DDR3_512MB_1GB_2GB/K4E6E304EE_EGCE/g" $DDR_H_FILE
elif [ "$DDR" == "RF" ]
then
	echo RF938.LCDDR3.2048.2DIE.32BIT.K4E6E304EE_EGCE+H9CKNNNBJTMPLR_NUH+H9CKNNNBJTMPLR_K4E8E
	sed -i "s/DDR_ANCHOR/DDR_938/g" $DDR_CLK_FILE
	# sed -i "s/MT8163_DDR3_512MB_1GB_2GB/H9CKNNNBJTMPLR_K4E8E/g" $DDR_H_FILE
	sed -i "s/MT8163_DDR3_512MB_1GB_2GB/H9CKNNNBJTMPLR_NUH/g" $DDR_H_FILE
	# awk '{print $0}/K4E6E304EE_EGCE/{print "#define CS_PART_NUMBER[1]      H9CKNNNBJTMPLR_NUH"}' $DDR_H_FILE > $PRELOADER_DIR"/custom/$PROJECT/inc/custom_MemoryDevice"
	# awk '{print $0}/H9CKNNNBJTMPLR_K4E8E/{print "#define CS_PART_NUMBER[1]      K4E6E304EE_EGCE"}' $DDR_H_FILE > $PRELOADER_DIR"/custom/$PROJECT/inc/custom_MemoryDevice"
	# mv $PRELOADER_DIR"/custom/$PROJECT/inc/custom_MemoryDevice"  $PRELOADER_DIR"/custom/$PROJECT/inc/custom_MemoryDevice.h"
elif [ "$DDR" == "RBB" ]
then
	echo RBB1066.PCDDR3.1024.2DIE.8BIT.H5TQ2G83EFR-PBC
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/MT8163_DDR3_512MB_1GB_2GB/H5TQ2G83EFR-PBC/g" $DDR_H_FILE
fi

elif [ "$PROJECT" == "tb8167p3_bsp" -o "$PROJECT" == "tb8167p5_64_bsp" -o "$PROJECT" == "tb8167p1_bsp_nand" ]
then
####################################### MT8167 DDR SET #########################################
if [ "$DDR" == "RA" ]
then
	echo RA1066.LPDDR3.1024.2DIE.32BIT.COMMON_LP3_168BALL
#	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/COMMON_DDR3_x32/COMMON_LP3_168BALL/g" $DDR_H_FILE
elif [ "$DDR" == "RB" ]
then
	echo RB1066.LPDDR3.1024.2DIE.32BIT.COMMON_LP3_178BALL
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/COMMON_DDR3_x32/COMMON_LP3_178BALL/g" $DDR_H_FILE
elif [ "$DDR" == "RC" ]
then
	echo RC1066.LPDDR3.1024.2DIE.32BIT.COMMON_LP3_211BALL
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/COMMON_DDR3_x32/COMMON_LP3_211BALL/g" $DDR_H_FILE
elif [ "$DDR" == "RD" ]
then
	echo RD1066.PCDDR3.1024.2DIE.8BIT.COMMON_DDR3_x8
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/COMMON_DDR3_x32/COMMON_DDR3_x8/g" $DDR_H_FILE
elif [ "$DDR" == "RE" ]
then
	echo RE1066.PCDDR3.1024.2DIE.16BIT.COMMON_DDR3_x16
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/COMMON_DDR3_x32/COMMON_DDR3_x16/g" $DDR_H_FILE
elif [ "$DDR" == "RF" ]
then
	echo RF1066.PCDDR3.1024.2DIE.32BIT.COMMON_DDR3_x32
	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/COMMON_DDR3_x32/COMMON_DDR3_x32/g" $DDR_H_FILE
fi

elif [ "$PROJECT" == "tb8176p1_64_bsp" ]
then
####################################### MT8167 DDR SET #########################################
if [ "$DDR" == "RA" ]
then
	echo RA1066.LPDDR3.3072.2DIE.64BIT.KMQ310006A_B419
#	sed -i "s/DDR_ANCHOR/DDR_1066/g" $DDR_CLK_FILE
	sed -i "s/H9TP32A8JDACPR_KGM/KMQ310006A_B419/g" $DDR_H_FILE
fi

fi



echo "Mid modify to exit compile, you do it manually"
exit 0
##################################################### BUILD #######################################
export ANDROID_JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=/usr/lib/jvm/java-8-openjdk-amd64/bin:$PATH

source build/envsetup.sh
lunch full_$PROJECT-userdebug

TARGET=bnd_"$PROJECT"_"$PCBA"
if [ ! -e  $TARGET ];then
    mkdir $TARGET > /dev/null
fi
echo ${ACTIONS[@]} | grep -wq "$4"
BOOL1=$?

if [ $# == 4 -a $BOOL1 == 0 ];then
        if [ "$4" == "n" -o "$4" == "new" ];then
                make clean
                make $MAKEJOBS # 2>&1 | tee $TARGET/new.log
        elif [ "$4" == "r" -o "$4" == "remake" ];then
        	make $MAKEJOBS # 2>&1 | tee $TARGET/remake_build.log
        else
                make $MAKEJOBS $4 # 2>&1  | tee $TARGET/"$4".log
        fi
elif [ $# -gt 4 ];then
        if [ "$4" == "n" -o "$4" == "new" ];then
                shift 4
                for i in $*
                do
                        echo ${ACTIONS[@]} | grep -wq "$i"
                        if [ $? == 0 ];then
                                if [ $i == "k" ];then
                                        argv=$argv" "kernel
                                else
                                        argv=$argv" "$i
                                fi
                        else
                                echo "Invaild actions. $i...!!!"
                                exit
                        fi
                    make $MAKEJOBS $argv # 2>&1  | tee $TARGET/"$i"_build.log
                done

        elif [ "$4" == "r" -o "$4" == "remake" ];then
                shift 4
                for i in $*
                do
                        echo ${ACTIONS[@]} | grep -wq "$i"
                        if [ $? == 0 ];then
                                if [ $i == "k" ];then
                                        argv=$argv" "kernel
                                else
                                        argv=$argv" "$i
                                fi
                        else
                                echo "Invaild actions. $i...!!!"
                                exit
                        fi
                    make $MAKEJOBS $argv # 2>&1  | tee $TARGET/"$i"_build.log
                done

        elif [ $# == 5 -a "$4" == "mm" -o "$4" == "mmm" ];then
                mmm $5
        elif [ $# == 5 -a "$4" == "mmma" ];then
                mmma $5
        else
                echo "Invaild actions."
        fi
else
        echo "Invaild actions."
fi


#cd $PRELOADER_DIR
#git checkout -- $DDR_H_FILE
#git checkout -- $DDR_CLK_FILE
#git checkout -- $PL_MAKEFILE
#git checkout -- $PL_DCT_DIR/codegen.dws
#cd - >> /dev/null
#
#cd $LK_DIR
#git checkout -- $LK_MAKEFILE
#git checkout -- $LK_DCT_DIR/codegen.dws
#cd - >>/dev/null
#
#cd $KERNEL_CONFIG_DIR
#git checkout -- $KL_DBG_CFG
#git checkout -- $KL_USER_CFG
#git checkout -- $KERNEL_DTS_DIR
#cd - >>/dev/null
#
#cd $KL_DCT_DIR
#git checkout -- codegen.dws
#cd - >>/dev/null
#
#cd device/mediateksample/$PROJECT
#git checkout -- ProjectConfig.mk
#cd - >>/dev/null
#
