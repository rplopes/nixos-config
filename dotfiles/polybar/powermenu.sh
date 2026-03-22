#!/usr/bin/env bash

chosen=$(printf "Shutdown\nReboot\nSuspend\nLock\nLog out" | rofi -dmenu -i -p " ")

case "$chosen" in
  Shutdown) systemctl poweroff ;;
  Reboot)   systemctl reboot ;;
  Suspend)  systemctl suspend ;;
  Lock)     i3lock ;;
  "Log out") i3-msg exit ;;
esac
