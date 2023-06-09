#!/bin/sh

TEMPDIR="${PWD}/tmp"
TEMPFILE="${TEMPDIR}/wifi.log"
NETCFG="${PWD}/conf/mlan0.conf"

EXIT=$1

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function wifi_test()
{
	DEV="mlan0"
	TIME=1
	THERSHOLD=2

	#IP_PREFIX="192.168.0"
	#LOCAL_IP="${IP_PREFIX}.150"
	#REMOTE_IP="${IP_PREFIX}.1"

	LOCAL_IP=`cat ${NETCFG} | grep ${DEV} | cut -d: -f2`
	REMOTE_IP=`cat ${NETCFG} | grep ${DEV} | cut -d: -f3`

	rm $TEMPFILE &> /dev/null

	#ifconfig mlan0 ${LOCAL_IP}
	ping -q -c $TIME ${REMOTE_IP} -I ${LOCAL_IP} | tee -a $TEMPFILE

	DUP=`cat $TEMPFILE | grep duplicate`

    if [ -z $DUP ]; then
        RET=`cat $TEMPFILE | grep packet | awk '{print $6}'`
    else
        RET=`cat $TEMPFILE | grep packet | awk '{print $8}'`
    fi

	if [ "$RET" == "0%" ]; then
		echo -e "\033[032m[WIFI] WiFi Test Passed.\033[0m"
	else
		echo -e "\033[031m[WIFI] WiFi Test Failed.\033[0m"
		fail_check
	fi

	sleep 2
}

wifi_test

