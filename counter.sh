#!/bin/bash

COUNTER=$1
COUNTER=$(( COUNTER * 60 ))

while true
do
	echo $COUNTER seconds remaining
	sleep 1
	COUNTER=$(( COUNTER - 1 ))
done
