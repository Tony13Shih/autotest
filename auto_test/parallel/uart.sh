#!/bin/sh

TEMPDIR="${PWD}/tmp"
TEMPFILE="${TEMPDIR}/uart.log"

EXIT=$1

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function uart_test()
{
	DEV="ttyLP1"

	WriteStr="1234"

	cat /dev/$DEV &> $TEMPFILE &
	sleep 1
	echo > $TEMPFILE
	#echo "Send=$WriteStr"
	echo $WriteStr > /dev/$DEV
	sleep 1
	ReadStr=$(tr -d '\0' < $TEMPFILE | grep "1234")
	#echo "Receive=$ReadStr"

	pkill cat

	if [ "$ReadStr" == "$WriteStr" ]; then
		echo -e "\033[32m[UART] /dev/$DEV Test Passed.\033[0m"
	else
		echo -e "\033[31m[UART] /dev/$DEV Test Failed.\033[0m"
		fail_check
	fi

	sleep 2
}

uart_test