#!/bin/sh

TEMPDIR="${PWD}/../tmp"
TEMPFILE="${TEMPDIR}/eth1.log"

DEV="eth1"
IP_PREFIX="169.254.0"

if [ $DEV == "eth0" ]; then
  LOCAL_IP="${IP_PREFIX}.100"
  REMOTE_IP="${IP_PREFIX}.200"
else
  LOCAL_IP="${IP_PREFIX}.200"
  REMOTE_IP="${IP_PREFIX}.100"
fi

#ifconfig eth1 ${LOCAL_IP}
ping -q -c 10 ${REMOTE_IP} -I ${LOCAL_IP} | tee -a $TEMPFILE

RET=`cat $TEMPFILE | grep packet | awk '{print $6}'`

if [ "$RET" == "0%" ]; then
        echo -e "\033[032m[ETH] eth1 Test Passed.\033[0m"
else
        echo -e "\033[031m[ETH] eth1 Test Failed.\033[0m"
fi

rm $TEMPFILE
