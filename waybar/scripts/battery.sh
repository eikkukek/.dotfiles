#!/bin/bash

read state pcent < <(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | awk '/state/ {state=$2} /percentage/ {pcent=$2}
	END { print state " " pcent }
')

pcent=${pcent%\%}

if [ "$state" == "charging" ]; then
	echo "{\"text\": \"󰂅  $pcent%\", \"class\": \"$1\"}"
fi

if [ "$pcent" -ge 100 ]; then
	class=$1
	symbol="󰁹"
elif [ "$pcent" -ge 90 ]; then
	class=$1
	symbol="󰂂"
elif [ "$pcent" -ge 80 ]; then
	class=$1
	symbol="󰂁"
elif [ "$pcent" -ge 70 ]; then
	class=$1
	symbol="󰂀"
elif [ "$pcent" -ge 60 ]; then
	class=$2
	symbol="󰁿"
elif [ "$pcent" -ge 50 ]; then
	class=$2
	symbol="󰁾"
elif [ "$pcent" -ge 40 ]; then
	class=$2
	symbol="󰁽"
elif [ "$pcent" -ge 30 ]; then
	class=$2
	symbol="󰁼"
elif [ "$pcent" -ge 20 ]; then
	class=$3
	symbol="󰁻"
else
	class=$3
	symbol="󰁺"
fi

echo "{\"text\": \"$symbol $pcent%\", \"class\": \"$class\"}"
