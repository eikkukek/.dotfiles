#!/bin/bash

session=$1

file_name="/tmp/.${session}"

while tmux ls | grep -q $session; do
	start=$SECONDS
	minutes=$((start / 60))
	hours=$((minutes / 60))
	seconds=$((start - minutes * 60))
	minutes=$((minutes - hours * 60))
	time=""
	if [ "$hours" -ne "0" ]; then
		time=$(printf "session time %i:%02i:%02i\n" \
			$hours $minutes $seconds)
	else
		time=$(printf "session time %02i:%02i\n" \
			$minutes $seconds)
	fi
	printf "$time\n" > $file_name
	client=$(tmux list-clients -t $session \
		| cut -d ':' -f1
	)
	tmux refresh-client -t $client -S
	while [ "$start" -eq "$SECONDS" ]; do
		:
	done
done

rm $file_name
