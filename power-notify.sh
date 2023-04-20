#!/usr/bin/env bash

while true
do
  	battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
  	battery_status=$(cat /sys/class/power_supply/BAT0/status)

	if [[ "$battery_status" == "Charging" && "$battery_level" -ge 68 ]]; then
		notify-send -t 3000 "Battery Full" "Level: ${battery_level}%"
	elif [[ "$battery_status" == "Discharging" && "$battery_level" -le 10 ]]; then
		notify-send -t 3000 "Battery Low" "Level: ${battery_level}%"
	fi
 	
	sleep 30
done
