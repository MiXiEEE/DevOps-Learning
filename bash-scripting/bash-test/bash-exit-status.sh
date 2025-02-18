#!/bin/bash
ls bash-second-read.sh
if [ $? -eq 0 ]; then
	echo "Command succeeded"
else
  	echo "Command failed"
fi
