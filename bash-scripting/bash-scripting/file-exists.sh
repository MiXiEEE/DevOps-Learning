#!/bin/bash
echo "Provide file, and its path"
read filepath
if [ -f "$filepath" ]; then
	echo "File exists"
else
	echo "File doesn't exist"
fi
