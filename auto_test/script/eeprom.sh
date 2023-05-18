#!/bin/sh

DEV="/sys/bus/i2c/devices/0-0050/eeprom"

WriteStr="HELLOWORLD!"

ReadStr=`hexdump -C $DEV -n 16 | awk '{print $18}' | cut -c 2-12`
	
sleep 1

if [ "$ReadStr" == "$WriteStr" ]; then
	echo -e "\033[32m[EEPROM] Read Test Passed.\033[0m"
else
	echo -e "\033[31m[EEPROM] Read Test Failed.\033[0m"
fi

