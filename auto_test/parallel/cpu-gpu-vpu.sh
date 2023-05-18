#!/bin/sh

source /unit_tests/test_utils.sh

V="{$PWD}/video/1.mp4"

while true
do

	cd /opt/viv_samples/vdk/ && ./tutorial3 -f 100 && cd - &> /dev/null
	cd /opt/viv_samples/vdk/ && ./tutorial4_es20 -f 100 && cd - &> /dev/null

	sleep 1

	echo 0 > /sys/devices/system/cpu/cpu0/online
	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 0 > /sys/devices/system/cpu/cpu2/online
	echo 0 > /sys/devices/system/cpu/cpu3/online

	stress-ng -c 2 --timeout 15s

	sleep 1

	echo 1 > /sys/devices/system/cpu/cpu0/online
	echo 1 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu2/online
	echo 1 > /sys/devices/system/cpu/cpu3/online

	echo 0 > /sys/devices/system/cpu/cpu4/online
	echo 0 > /sys/devices/system/cpu/cpu5/online

	stress-ng -c 4 --timeout 15s
	
	sleep 1

	echo 1 > /sys/devices/system/cpu/cpu4/online
	echo 1 > /sys/devices/system/cpu/cpu5/online

	gst-launch-1.0 filesrc location=$V ! decodebin ! imxvideoconvert_g2d ! queue ! autovideosink &

	sleep 30

	killall -9 gst-launch-1.0

	sleep 1
	
done