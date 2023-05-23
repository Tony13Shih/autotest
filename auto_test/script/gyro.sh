#!/bin/sh

EXIT=$1

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function gyro_test()
{
	RET=`i2cdetect -y -r 2 | grep 60 | cut -d ' ' -f 12`

	if [ "$RET" == "UU" ];then
		echo -e "\033[32m[GYRO] Test Passed.\033[0m"
	else
		echo -e "\033[31m[GYRO] Test Failed.\033[0m"
		fail_check
	fi

	sleep 2
}

gyro_test

