#!/bin/sh

RET=`i2cdetect -y -r 2 | grep 60 | cut -d ' ' -f 12`

if [ $RET == "UU" ];then
	echo -e "\033[32m[GYRO] Passed.\033[0m"
else
	echo -e "\033[31m[GYRO] Failed.\033[0m"
fi
