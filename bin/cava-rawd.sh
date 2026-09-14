#!/bin/bash

set -euo pipefail

restart_cava() {
	pkill -TERM cava || true
	sleep 0.3
	cava | awk '{
		subbed = gsub(";"," ")
		for (i = 1; i <= subbed; i++) {
			printf "%d\n", $i / 255 * 100 > "/tmp/.cava-raw"
		}
		close("/tmp/.cava-raw")
	}'
}

restart_cava &

pactl subscribe | while read -r line; do
	case "$line" in
		*"Event 'changed' on sink"*)
			pkill -TERM cava
			;;
	esac
done
