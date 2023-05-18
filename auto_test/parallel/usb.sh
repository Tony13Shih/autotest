#!/bin/sh

EXIT=$1
SIZE=${SIZE:=1024}

function fail_check()
{
	if [ ! -z $EXIT ]; then
		exit 1
	fi
}

function usb_test()
{
	USBDEV=$1

	dd if=/dev/${USBDEV} of=/tmp/data_${USBDEV}_bak bs=1 count=$SIZE skip=4096 &>/dev/null

	if [ -e "/tmp/data_${USBDEV}_bak" ]; then
		rm /tmp/data_${USBDEV}_bak
		sync

		dd if=/tmp/data_usb of=/dev/${USBDEV} bs=1 seek=4096 &> /dev/null

		echo -e "\033[32m[USB] /dev/${USBDEV} Read/Write Passed.\033[0m"

	else
		echo -e "\033[31m[USB] /dev/${USBDEV} Read/Write Failed.\033[0m"
		fail_check
	fi

}

usb_test sda
sleep 1
usb_test sdb
sleep 1
usb_test sdc
sleep 1
