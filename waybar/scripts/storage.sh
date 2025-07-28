mnt="$1"
name="$2"

read avail pcent < <(df --output=avail,pcent "$mnt" | tail -1)

pcent=${pcent%\%}

if [ "$pcent" -ge 90 ]; then
	class=$5
elif [ "$pcent" -ge 70 ]; then
	class=$4
else
	class=$3
fi

size=$((avail * 100 / (100 - pcent) >> 20))
avail=$((avail >> 20))
used=$((size - avail))

echo "{\"text\": \"  $name $avail GiB\", \"alt\": \"$used GiB / $size GiB ($pcent%)\", \"class\": \"$class\"}"
