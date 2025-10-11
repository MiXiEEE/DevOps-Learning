#!/bin/bash

read -rp "Enter your number from 1-5: " number

if [[ "$number" =~ ^[1-5]$ ]]; then
	case $number in
		"1")
			echo "you picked option 1"
			;;
		"2")
			echo "you picked option 2"
			;;
		"3")
			echo "you picked option 3"
			;;
		"4")
			echo "you picked option 4"
			;;
		"5")
			echo "you picked option 5"
			;;
	esac
else
	echo "invalid input!"
fi
