#!/bin/sh

EXIT=$1

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function gmsl_test()
{
	GMSL1=`i2cdetect -y -r 4 | grep 40 | cut -d ' ' -f 10`
	GMSL2=`i2cdetect -y -r 5 | grep 40 | cut -d ' ' -f 10`

	if [ "$GMSL1" == "48" ] && [ "$GMSL2" == "48" ]; then
		echo -e "\033[32m[GMSL] Test Passed.\033[0m"
	else
		echo -e "\033[31m[GMSL] Test Failed.\033[0m"
	fi
}

gmsl_test


