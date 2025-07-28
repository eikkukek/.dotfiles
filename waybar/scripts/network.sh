#!/bin/sh

active_iface=$(ip route get 8.8.8.8 | awk '{for (i=1; i<=NF; i++) if ($i=="dev") print $(i+1)}')

if [ -z "$active_iface" ]; then
	echo "{\"text\": \"󰤮\", \"alt\": \"no connection\", \"class\": \"alert\"}"
	EXIT
fi

if [ -d "/sys/class/net/$active_iface/wireless" ]; then
	read ssid rssi < <(iwctl station $active_iface show | awk '/Connected network/ {ssid=$3} /AverageRSSI/ {rssi=$2}
		END { print ssid " " rssi }')
	class="info"
	if [ -80 -ge "$rssi" ]; then
		symbol="󰤫"
		class="alert"
	elif [ -70 -ge "$rssi" ]; then
		symbol="󰤟"
	elif [ -60 -ge "$rssi" ]; then
		symbol="󰤢"
	elif [ -50 -ge "$rssi" ]; then
		symbol="󰤥"
	else
		symbol="󰤨"
	fi
	echo "{\"text\": \"${symbol}  $active_iface\", \"alt\": \"wifi connection ($ssid)\", \"class\": \"$class\"}"
else
	echo "{\"text\": \"  $active_iface\", \"alt\": \"ethernet connection\", \"class\": \"info\"}"
fi
