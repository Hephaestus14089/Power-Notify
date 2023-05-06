#!/usr/bin/env bash

usage() {
	echo "usage: ./power-notify.sh <lower_limit> <upper_limit>"
	echo "limits must be battery charge percentages."
}

check_args() {
	if [ "$#" -lt 2 ]; then
		usage
		exit 1
	elif [ "$1" -eq "$2" ]; then
		echo "Two limits must not be same!"
		echo ""
		usage
		exit 1
	fi

	if [ "$1" -gt "$2" ]; then
		lower_limit="$2"
		upper_limit="$1"
	fi

	if [[ "$lower_limit" -le 0 || "$upper_limit" -gt 100 ]]; then
		echo "lower limit cannot be less than or equal to zero"
		echo "upper limit cannot be greater than 100"
		exit 1
	fi
}

start_listener() {
	while true
	do
  		battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
  		battery_status=$(cat /sys/class/power_supply/BAT0/status)

		# suspend to RAM
		if [[ "$battery_status" == "Discharging" && "$battery_level" -le "$suspend_limit" ]]; then
			loginctl suspend
		fi

		if [[ "$battery_status" == "Charging" && "$battery_level" -ge "$upper_limit" ]]; then
			notify-send -t 3000 "Battery Full" "Level: ${battery_level}%"
		elif [[ "$battery_status" == "Discharging" && "$battery_level" -le "$lower_limit" ]]; then
			notify-send -t 3000 "Battery Low" "Level: ${battery_level}%"
		fi

		sleep 60
	done
}


lower_limit="$1"
upper_limit="$2"

suspend_limit=5

check_args "$@"
start_listener
