#!/bin/bash
user_agent="waybar-weather-daemon"
interval=60
cache="/tmp/.waybar_weather"

while true; do

	#loc=$(curl -sf https://ipinfo.io/json | jq -r '.loc')
	#lat=${loc%,*}
	#lon=${loc#*,}

	lat=64.21
	lon=27.75

	url="https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$lat&lon=$lon"

	timeseries=".properties.timeseries"

	json=$(curl -sf -H "User-Agent: waybar-weather" "$url")

	temperature=$(echo "$json" | jq -r '.properties.timeseries[0].data.instant.details.air_temperature')

	symbol=$(echo "$json" | jq -r '.properties.timeseries[0].data.next_1_hours.summary.symbol_code')

	case $symbol in
		clearsky_day) symbol="󰖙 " description="clear sky" ;;
		clearsky_night) symbol=" " description="clear sky" ;;
		partlycloudy_day) symbol=" " description="partly cloudy" ;;
		partlycloudy_night) symbol=" " description="partly cloudy" ;;
		cloudy) symbol="󰖐 " description="cloudy" ;;
		rain) symbol=" " description="rain" ;;
		lightrain) symbol=" " description="light rain" ;;
		heavyrain) symbol=" " description="heavy rain" ;;
		fair_day) symbol=" " description="fair" ;;
		fair_night) symbol="󰼱 " description="fair" ;;
		snow) symbol="󰖘 " description="snow" ;;
		lightsnow) symbol="󰖘 " description="light snow" ;;
		heavysnow) symbol="󰖘 " description="heavy snow" ;;
		fog) symbol=" " description="fog" ;;
		thunderstorm) symbol="󰖓 " description="thunder" ;;
		*) description=$symbol symbol="" ;;
	esac

	echo "{\"text\": \"${symbol}$temperature°C\", \"alt\": \"$description\"}" > "$cache"
	sleep "$interval"
done
