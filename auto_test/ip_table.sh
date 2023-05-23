#!/bin/sh

if [ ${1} == "l" ]; then
    CONFDIR="${PWD}/script/conf"
else
    CONFDIR="${PWD}/conf"
fi

mkdir -p ${CONFDIR}

ETH0="eth0"
IP_ETH0="169.254.0.200"
CFG_ETH0="${CONFDIR}/eth0.conf"
ETH1="eth1"
IP_ETH1="169.254.0.100"
CFG_ETH1="${CONFDIR}/eth1.conf"

ifconfig ${ETH0} ${IP_ETH0}
ifconfig ${ETH1} ${IP_ETH1}

IP_ETH0=`ifconfig ${ETH0} | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`
IP_ETH1=`ifconfig ${ETH1} | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`

if [ -z ${IP_ETH0} ] || [ -z ${IP_ETH1} ]; then
    echo -e "\033[31mNo ${ETH0} or ${ETH1} ip address.\033[0m"
    exit 1
fi

echo "${ETH0}:${IP_ETH0}:${IP_ETH1}" > ${CFG_ETH0} 
echo "${ETH1}:${IP_ETH1}:${IP_ETH0}" > ${CFG_ETH1}

MLAN0="mlan0"
IP_MLAN0=`ifconfig ${MLAN0} | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`
CFG_MLAN0="${CONFDIR}/mlan0.conf"

if [ -z ${IP_MLAN0} ]; then
    echo -e "\033[31mNo ${MLAN0} ip address.\033[0m"
    exit 1
fi

REMOTE_MLAN0="`echo ${IP_MLAN0} | cut -d. -f1-3`.1"
echo "${MLAN0}:${IP_MLAN0}:${REMOTE_MLAN0}" > ${CFG_MLAN0}

WWAN0="wwan0"
IP_WWAN0=`ifconfig ${WWAN0} | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`
CFG_WWAN0="${CONFDIR}/wwan0.conf"

if [ -z ${IP_WWAN0} ]; then
    echo -e "\033[31mNo ${WWAN0} ip address.\033[0m"
    exit 1
fi

REMOTE_WWAN0="8.8.8.8"
echo "${WWAN0}:${IP_WWAN0}:${REMOTE_WWAN0}" > ${CFG_WWAN0}