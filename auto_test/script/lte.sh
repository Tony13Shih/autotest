#!/bin/sh

TEMPDIR="${PWD}/tmp"
TEMPFILE="${TEMPDIR}/lte.log"
NETCFG="${PWD}/conf/wwan0.conf"

EXIT=$1

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function lte_test()
{
	DEV="wwan0"
	TIME=1
	
	#IP_PREFIX="192.168.0"
	#LOCAL_IP="${IP_PREFIX}.150"
	#REMOTE_IP="${IP_PREFIX}.1"

    LOCAL_IP=`cat ${NETCFG} | grep ${DEV} | cat -d: -f2`
    REMOTE_IP=`cat ${NETCFG} | grep ${DEV} | cat -d: -f3`

	rm $TEMPFILE &> /dev/null

	#ifconfig wwan0 ${LOCAL_IP}
	ping -q -c $TIME ${REMOTE_IP} -I ${LOCAL_IP} | tee -a $TEMPFILE

    DUP=`cat $TEMPFILE | grep duplicate`

    if [ -z $DUP ]; then
        RET=`cat $TEMPFILE | grep packet | awk '{print $6}'`
    else
        RET=`cat $TEMPFILE | grep packet | awk '{print $8}'`
    fi

	if [ "$RET" == "0%" ]; then
		echo -e "\033[032m[LTE] LTE Test Passed.\033[0m"
	else
		echo -e "\033[031m[LTE] LTE Test Failed.\033[0m"
		fail_check
	fi

	sleep 2
}

lte_test

