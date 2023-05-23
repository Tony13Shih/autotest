#!/bin/sh

TEMPERATURE0=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
TEMPERATURE1=$(cat /sys/devices/virtual/thermal/thermal_zone1/temp)
TEMPERATURE4=$(cat /sys/devices/virtual/thermal/thermal_zone4/temp)
CPU_FREQUENCY=`cpufreq-info -f`

echo "$TEMPERATURE0" | awk '{printf ("\033[032m[TEMP] A53  : %.2f C\n\033[0m", $1/1000)}'
echo "$TEMPERATURE1" | awk '{printf ("\033[032m[TEMP] A72  : %.2f C\n\033[0m", $1/1000)}'
echo "$TEMPERATURE4" | awk '{printf ("\033[032m[TEMP] PMIC : %.2f C\n\033[0m", $1/1000)}'
echo -e "\033[032m[TEMP] CPU Frequency:$CPU_FREQUENCY\033[0m"

sleep 2