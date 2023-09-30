#!/usr/bin/env bash

usage() {
	echo "usage: ./power-notify.sh <lower_limit> <upper_limit>"
	echo "limits are interpreted as battery charge percentages."
}

check_args() {
	if [ "$#" -lt 2 ]; then
		usage
		exit 1
	elif [ "$1" -eq "$2" ]; then
		echo "error: upper and lower limits must not be equal"
		echo ""
		usage
		exit 1
	fi

	if [ "$1" -gt "$2" ]; then
		lower_limit="$2"
		upper_limit="$1"
	fi
}

check_vals() {
	if [[ "$upper_limit" -gt 100 ]]; then
		echo "error: upper limit cannot be greater than 100"
		exit 1
	fi

	if [[ "$lower_limit" -le 0 ]]; then
		echo "warning: you might want to recheck your lower_limit value"
		echo "current value (lower_limit): ${lower_limit}"
		echo ""
		echo "setting lower_limit to be less than zero is eqivalent to not receiving a lower limit notification."
	fi

	if [[ "$suspend_limit" -ge 100 ]]; then
		echo "error: suspend limit must be less than 100"
		exit 1
	fi

	if [[ "$suspend_limit" -gt 50 ]]; then
		msg="warning: you might want to recheck your suspend_limit value"
		if [[ "$suspend_limit" -gt 80 ]]; then
			msg="warning: please, for the sake of sanity, recheck your suspend_limit value"
		fi
		echo "$msg"
		echo "current value (suspend_limit): $suspend_limit"
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
check_vals
start_listener
