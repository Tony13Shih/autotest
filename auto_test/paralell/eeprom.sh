#!/bin/sh

EEPROM="/sys/bus/i2c/devices/0-0050/eeprom"

EXIT=$1

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function eeprom_test()
{
	DEV=$1

	WriteStr="HELLOWORLD!"

	ReadStr=`hexdump -C $DEV -n 16 | awk '{print $18}' | cut -c 2-12`

	if [ "$ReadStr" == "$WriteStr" ]; then
		echo -e "\033[32m[EEPROM] Read Test Passed.\033[0m"
	else
		echo -e "\033[31m[EEPROM] Read Test Failed.\033[0m"
		fail_check
	fi

	sleep 1
}

eeprom_test $EEPROM