#!/bin/sh

EXIT=$1
SIZE=${SIZE:=1024}

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function emmc_partition()
{

	MMCDEV=$1

	RET=`fdisk -l /dev/${MMCDEV} | grep "${MMCDEV}p1"`
	if [ -z "$RET" ]; then
        umount /dev/${MMCDEV}p1 &> /dev/null
        fdisk /dev/${MMCDEV} &> /dev/null << EOF
n
p
1


w
EOF
	fi

}

function emmc_test() 
{

	MMCDEV=$1

	dd if=/dev/${MMCDEV}p1 of=/tmp/data_${MMCDEV}_bak bs=1 count=$SIZE skip=4096 &> /dev/null
	if [ -e "/tmp/data_${MMCDEV}_bak" ]; then
		rm /tmp/data_${MMCDEV}_bak
		sync

		dd if=/tmp/data_emmc of=/dev/${MMVDEV}p1 bs=1 seek=4096 &> /dev/null

		echo -e "\033[32m[EMMC] /dev/${MMCDEV}p1 Read/Write Passed.\033[0m"
	else
		echo -e "\033[32m[EMMC] /dev/${MMCDEV}p1 Read/Write Failed.\033[0m"
		fail_check
	fi

	sleep 2
}

emmc_partition mmcblk1
emmc_test mmcblk1
