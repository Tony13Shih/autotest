#!/bin/sh

TEMPDIR="${PWD}/../tmp"
TEMPFILE="${TEMPDIR}/wifi.log"

DEV="mlan0"
IP_PREFIX="192.168.0"

LOCAL_IP="${IP_PREFIX}.150"
REMOTE_IP="${IP_PREFIX}.1"

#ifconfig eth0 ${LOCAL_IP}
ping -q -c 10 ${REMOTE_IP} -I ${LOCAL_IP} | tee -a $TEMPFILE

RET=`cat $TEMPFILE | grep packet | awk '{print $6}'`

if [ "$RET" == "0%" ]; then
	echo -e "\033[032m[WIFI] WiFi Test Passed.\033[0m"
else
	echo -e "\033[031m[WIFI] WiFi Test Failed.\033[0m"
fi

rm $TEMPFILE
