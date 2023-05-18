#!/bin/sh

DEBUG=0
GPIODIR="/sys/class/gpio"

# --------------- GPIO set up ---------------

# iMX8_Colay_DO0
if [ ! -e "${GPIODIR}/gpio1" ]; then
        echo 452 > ${GPIODIR}/export
        echo out > ${GPIODIR}/gpio1/direction
fi

# iMX8_Colay_DI0
if [ ! -e "${GPIODIR}/gpio2" ]; then
        echo 453 > ${GPIODIR}/export
        echo in > ${GPIODIR}/gpio2/direction
fi

# iMX8_Colay_DO1
if [ ! -e "${GPIODIR}/gpio3" ]; then
        echo 458 > ${GPIODIR}/export
        echo out > ${GPIODIR}/gpio3/direction
fi

# iMX8_Colay_DI1
if [ ! -e "${GPIODIR}/gpio4" ]; then
        echo 459 > ${GPIODIR}/export
        echo in > ${GPIODIR}/gpio4/direction
fi

# iMX8_Colay_DO2
if [ ! -e "${GPIODIR}/gpio5" ]; then
        echo 475 > ${GPIODIR}/export
        echo out > ${GPIODIR}/gpio5/direction
fi

# iMX8_Colay_DI2
if [ ! -e "${GPIODIR}/gpio6" ]; then
        echo 476 > ${GPIODIR}/export
        echo in > ${GPIODIR}/gpio6/direction
fi

# iMX8_Colay_DO3
if [ ! -e "${GPIODIR}/gpio7" ]; then
        echo 478 > ${GPIODIR}/export
        echo out > ${GPIODIR}/gpio7/direction
fi

# iMX8_Colay_DI3
if [ ! -e "${GPIODIR}/gpio8" ]; then
        echo 479 > ${GPIODIR}/export
        echo in > ${GPIODIR}/gpio8/direction
fi

# --------------- Set DO* value ---------------

RET=`cat ${GPIODIR}/gpio1/value`

if [ $RET == "1" ]; then
	VAL=0
else
	VAL=1
fi

echo $VAL > "${GPIODIR}/gpio1/value"
echo $VAL > "${GPIODIR}/gpio3/value"
echo $VAL > "${GPIODIR}/gpio5/value"
echo $VAL > "${GPIODIR}/gpio7/value"

sleep 1

RET2=`cat ${GPIODIR}/gpio2/value`
RET4=`cat ${GPIODIR}/gpio4/value`
RET6=`cat ${GPIODIR}/gpio6/value`
RET8=`cat ${GPIODIR}/gpio8/value`

if [ $DEBUG == 1 ]; then
	echo "[DO0] = $VAL <==> [DI0] = $RET2"
	echo "[DO1] = $VAL <~=> [DI1] = $RET4"
	echo "[DO2] = $VAL <~=> [DI2] = $RET6"
	echo "[DO3] = $VAL <~=> [DI3] = $RET8"
else
	if [ $RET2 -eq $VAL ]; then
		echo -e "\033[32m[GPIO] DO0 <-> DI0 : Passed.\033[0m"
	else
		echo -e "\033[31m[GPIO] DO0 <-> DI0 : Failed.\033[0m"
	fi

	if [ $RET4 -ne $VAL ]; then
		echo -e "\033[32m[GPIO] DO1 <~> DI1 : Passed.\033[0m"
	else
		echo -e "\033[31m[GPIO] DO1 <~> DI1 : Failed.\033[0m"
	fi

	if [ $RET6 -ne $VAL ]; then
		echo -e "\033[32m[GPIO] DO2 <~> DI2 : Passed.\033[0m"
	else
		echo -e "\033[31m[GPIO] DO2 <~> DI2 : Failed.\033[0m"
	fi

	if [ $RET8 -ne $VAL ]; then
		echo -e "\033[32m[GPIO] DO3 <~> DI3 : Passed.\033[0m"
	else
		echo -e "\033[31m[GPIO] DO3 <~> DI3 : Failed.\033[0m"
	fi	
fi
