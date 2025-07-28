#!/bin/bash

read cpu user nice system idle rest < /proc/stat

busy=$(( (user+system) ))
total=$(( (user+nice+system+idle) ))

usage=$((busy * 100 / total ))

if [ "$usage" -ge 90 ]; then
	class=$3
elif [ "$usage" -ge 70 ]; then
	class=$2
else
	class=$1
fi

echo "{\"text\": \"  ${usage}%\", \"class\": \"$class\"}"
