#!/usr/bin/env bash
#  ____                                                    
# |  _ \ _____      _____ _ __ _ __ ___   ___ _ __  _   _  
# | |_) / _ \ \ /\ / / _ \ '__| '_ ` _ \ / _ \ '_ \| | | | 
# |  __/ (_) \ V  V /  __/ |  | | | | | |  __/ | | | |_| | 
# |_|   \___/ \_/\_/ \___|_|  |_| |_| |_|\___|_| |_|\__,_| 
#                                                          
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

echo 󰐥;

option1="  lock"
option2="  logout"
option3="  reboot"
option4="  power off"

options="$option1\n"
options="$options$option2\n"
options="$options$option3\n$option4"

choice=$(echo -e "$options" | rofi -dmenu -i -no-show-icons -theme ~/.cache/wal/colors-rofi-dark.rasi -l 4 -width 30 -p "Powermenu") 

case $choice in
	$option1)
		hyprlock || light-locker-command -l;;
	$option2)
		hyprctl dispatch exit || i3-msg exit;;
	$option3)
		systemctl reboot ;;
	$option4)
		systemctl poweroff ;;
esac