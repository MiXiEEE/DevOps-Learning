#!/bin/bash
echo "Input how many loops you wanna do"
read -r loopCount
#for ((i=1; i<=loopCount; i++))
#do
#	echo "$i"
#done

for i in $(seq 1 "$loopCount")
do
	echo "$i"
done
