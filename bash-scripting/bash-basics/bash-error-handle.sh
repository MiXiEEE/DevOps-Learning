#!/bin/bash
set -e
echo "this will run"
ls /nonexistent #this will casue the script to exit
echo "this will not run"
