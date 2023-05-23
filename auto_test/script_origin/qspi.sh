#!/bin/sh

DEV="/dev/mtd0"

head=`hexdump -C $DEV -n 16 | head -n 1 | cut -d ' ' -f 3` # 01
tail=`hexdump -C $DEV -n 16 | head -n 1 | cut -d ' ' -f 8` # 06

if [ "$head" == "01" ] && [ "$tail" == "06" ]; then
	echo -e "\033[32m[QSPI] Read Test Passed.\033[0m"
else
	echo -e "\033[31m[QSPI] Read Test Failed.\033[0m"
fi
