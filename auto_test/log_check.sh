#!/bin/sh

function print()
{

	DEV=$1
	PASS=`cat $LOGFILE | grep -a "${2} Passed." | wc -l`
	FAIL=`cat $LOGFILE | grep -a "${2} Failed." | wc -l`

	echo "[$1] Pass / Fail = ${PASS} / ${FAIL}"
}

LOGDIR="log"
LOGFILE="${LOGDIR}/*_testLog.txt"

print "CAN" "\[CAN\] can1 <--> can0 Test"
print "CAN" "\[CAN\] can1 <--> can2 Test"
print "CAN" "\[CAN\] can3 <--> can4 Test"
print "CAN" "\[CAN\] can5 <--> can6 Test"
print "CPU" "\[CPU\] Test"

print "EEPROM" "\[EEPROM\] Read Test"
print "ETH0" "\[ETH\] eth0 Test"
print "ETH1" "\[ETH\] eth1 Test"

print "GMSL" "\[GMSL\] Test"
print "GPIO_0" "\[GPIO\] DO0 <-> DI0 :"
print "GPIO_1" "\[GPIO\] DO1 <~> DI1 :"
print "GPIO_2" "\[GPIO\] DO2 <~> DI2 :"
print "GPIO_3" "\[GPIO\] DO3 <~> DI3 :"
print "GPU"  "\[GPU\] Test"
print "GYRO" "\[GYRO\]"

print "QSPI" "\[QSPI\] Read Test"

print "UART" "\[UART\] /dev/ttyLP1 Test"
print "USB_A"  "\[USB\] /dev/sda Read/Write"
print "USB_B"  "\[USB\] /dev/sdb Read/Write"
print "USB_C"  "\[USB\] /dev/sdc Read/Write"

print "VPU" "\[VPU\] Test"

print "WIFI" "\[WIFI\] WiFi Test"