#!/bin/sh

TEMPDIR="${PWD}/../tmp"
TEMPFILE="${TEMPDIR}/can.log"

EXIT=$1

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function can_test()
{

	if [ -z "`ifconfig -a | grep $1`" ]; then
		echo "Error : No such CAN device exist : $1"
		fail_check
	fi

	if [ -z "`ifconfig -a | grep $2`" ]; then
		echo "Error : No such CAN device exist : $2"
		fail_check
	fi

	if [ -z "`ifconfig | grep $1`" ]; then
		ip link set $1 up type can bitrate 125000
		ifconfig $1 up
	fi

	# candump $1 &

	if [ -z "`ifconfig | grep $2`" ]; then
		ip link set $2 up type can bitrate 125000
		ifconfig $2 up
	fi

	rm $TEMPFILE &> /dev/null

	candump $2 > $TEMPFILE &

	sleep 1

	cansend $1 1F334455#1122334455667788

	pkill candump

	head=`cat $TEMPFILE | cut -d ' ' -f 10`
	tail=`cat $TEMPFILE | cut -d ' ' -f 17`

	if [ "$head" == "11" ] && [ "$tail" == "88" ]; then
		echo -e "\033[32m[CAN] $1 <--> $2 Test Passed.\033[0m"
	else
		echo -e "\033[31m[CAN] $1 <--> $2 Test Failed.\033[0m"
		fail_check
	fi
}

can_test can1 can0
sleep 1
can_test can1 can2
sleep 1
can_test can3 can4
sleep 1
can_test can5 can6
sleep 1
