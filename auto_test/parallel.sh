#!/bin/sh

SH=$1
EXIT=$2

function pskill()
{
    killall -9 parallel.sh &> /dev/null
    killall -9 cpu-gpu-vpu.sh &> /dev/null
}

function test()
{
    ./$1 $2
}

function run_then_catch()
{
	test $1 $2
    ret=$?

    [[ $ret -ne 0 ]] && pskill && return 1
    return 0
}

while run_then_catch $SH $EXIT;
do
    sleep 3
done