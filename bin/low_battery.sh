#!/bin/bash

notified=0

while true
do
	read state pcent < <(upower -b | awk '/state/ {state=$2} /percentage/ {pcent=$2}
		END { print state " " pcent }
	')

	if [ "$state" == "charging" ]; then
		notified=0
		continue
	fi

	pcent=${pcent%\%}

	if [ $notified -ne 1 ] && [ "$pcent" -le 20 ]; then
		notify-send "low battery!"
		notified=1
	elif [ "$pcent" -le 10 ]; then
		notify-send "charge now!!!!!"
	fi

	sleep 5
done
