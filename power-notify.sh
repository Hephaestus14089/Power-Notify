#!/usr/bin/env bash

while true
do
  	battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
	
	if [ "$battery_level" -ge 90 ]; then
		notify-send "Battery Full" "Level: ${battery_level}%"
	elif [ "$battery_level" -le 10 ]; then
		notify-send --urgency=CRITICAL "Battery Low" "Level: ${battery_level}%"
	fi
 	
	sleep 30
done
