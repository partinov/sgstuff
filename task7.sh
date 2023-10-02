#!/bin/bash

# Check if Second and Third arguments are the same length
if [ ${#2} != ${#3} ];then
	echo "Second and third argument should have the same length!"
	exit
fi

if [ "$1" = "0" ]; then
	echo "${2} ${3}"
elif [ "$1" = "1" ]; then
	echo "${3} ${2}"
else
	echo "Please specify either 0 or 1 for first argument!"
fi