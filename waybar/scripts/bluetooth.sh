#!/bin/bash

read device name pcent < <(bluetoothctl info | awk '/Device/ {device=$2} /Name/ {name=$2}
	/Battery Percentage/ { gsub("\\(",""); gsub("\\)", ""); pcent=$4; }
	END { print device " " name " " pcent }
')

symbol=""

if [[ -z "$device" ]] then
	echo "{\"text\": \"${symbol}\", \"alt\": \"no bluetooth device connected\",}"
fi

if [[ -z "$pcent" ]]; then
	echo "{\"text\": \"${symbol}\", \"alt\": \"$device $name\",}"
else
	echo "{\"text\": \"${symbol}\", \"alt\": \"$device $name (battery: $pcent%)\",}"
fi
