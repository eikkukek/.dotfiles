#!/bin/bash

read pcent used total < <(free | awk '/Mem:/ { printf "%i %.1f %.1f", $3*100/$2, $3/1048576.0, $2/1048576.0 }')

if [ "$pcent" -ge 90 ]; then
	class=$3
elif [ "$pcent" -ge 70 ]; then
	class=$2
else
	class=$1
fi

echo "{\"text\": \"  $pcent%\", \"alt\": \"$used GiB / $total GiB\", \"class\": \"$class\"}"
