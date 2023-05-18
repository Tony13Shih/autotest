#!/bin/sh

if [ ! -e "${PWD}/log" ]; then
	mkdir log
fi

if [ -e "${PWD}/log/*_testLog.txt" ]; then
	rm "${PWD}/log/*"
fi

if [ ! -e "${PWD}/tmp" ]; then
	mkdir tmp
fi

echo "disabled" > /sys/devices/virtual/thermal/thermal_zone0/mode 
echo "disabled" > /sys/devices/virtual/thermal/thermal_zone1/mode
echo "disabled" > /sys/devices/virtual/thermal/thermal_zone4/mode
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

function init()
{
	ifconfig eth0 169.254.0.200
	ifconfig eth1 169.254.0.100

	stty -F /dev/ttyLP1 speed 115200 raw -echo &

	echo "HELLOWORLD!" > /sys/bus/i2c/devices/0-0050/eeprom

	flash_erase /dev/mtd0 0 1
	echo -n $'\x01\x02\x03\x04\x05\x06' > /dev/mtd0
	
	dd if=/dev/urandom of=/tmp/data_emmc bs=1 count=1024 &> /dev/null

	dd if=/dev/urandom of=/tmp/data_usb bs=1 count=1024 &> /dev/null
}

function runtest()
{
        ./${1}
}

function autorun()
{
        fileList=$(ls -R ${1})
        pushd ${1} >> /dev/null
	echo "-------------------- Round ${COUNT} ----------------------" | tee -a ${2}
        for filename in ${fileList}
	do

	if [[ "${filename}" == *.sh ]]; then
		echo "Test ${filename} ..." | tee -a ${2}
		RET=`runtest ${filename} | tee -a ${2} | grep -E "Passed|Failed|TEMP"`
		echo $RET
		ERR=`echo $RET | grep "Failed"`
		if [[ ${ERR} != "" ]]; then
			echo "[${COUNT}] $DAT ${ERR}" >> ${2}.err
		fi
		
		echo "Test ${filename} done" >> ${2}
		echo "------------------------------------------" >> ${2}
	fi

	done
        popd >> /dev/null
}

DATE=`date +%Y%m%d.%H.%M.%S`
COUNT=0
logPath="${PWD}/log"
START_TIME=`date +%s`
echo "start testing ${1}"
echo "make test log file ${DATE}_testLog"
echo "${DATE}_testLog log" > ${logPath}/${DATE}_testLog.txt
echo "${DATE} Error log" > ${logPath}/${DATE}_testLog.txt.err

init

sleep 3

case ${1} in
  "a")
        autorun auto_test ${DATE}_testLog.txt
        cat auto_test/${DATE}_testLog.txt
        ;;
  "c")
        autorun custom_test ${DATE}_testLog.txt
        ;;
  "script/")
		chmod a+x ${1}*.sh
        while true
        do
                ((COUNT++))
                NOW_TIME=`date +%s`
                Cost=$((NOW_TIME - START_TIME))
                DAT=`date -d @$Cost -u | cut -d" " -f 5`
                clear
                #echo "Testing Times:$COUNT, Running Time:$DAT"
                echo -e "\033[40;37mTesting Counts:$COUNT, Running Time:$DAT\033[0m"
                #cat ${logPath}/${DATE}_testLog.txt.err
                printf "\033[40;37m\033[0m"
                autorun ${1} ${logPath}/${DATE}_testLog.txt 
                sleep 2
        done
        ;;
  *)
        autorun ${1} ${DATE}_testLog.txt
        echo "Packaging all tests you want into dir /custom_test"
        echo "For single test type dir like /test_sdcard"
        ;;
esac
