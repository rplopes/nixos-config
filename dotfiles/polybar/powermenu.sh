#!/usr/bin/env bash

ICON_SHUTDOWN=$'\uf011'
ICON_REBOOT=$'\uf01e'
ICON_SUSPEND=$'\uf186'
ICON_LOCK=$'\uf023'
ICON_LOGOUT=$'\uf2f5'

chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$ICON_LOCK" "$ICON_SUSPEND" "$ICON_REBOOT" "$ICON_LOGOUT" "$ICON_SHUTDOWN" \
  | rofi -dmenu -p "Power" -theme ~/.config/rofi/powermenu.rasi)

case "$chosen" in
  "$ICON_SHUTDOWN") systemctl poweroff ;;
  "$ICON_REBOOT")   systemctl reboot ;;
  "$ICON_SUSPEND")  systemctl suspend ;;
  "$ICON_LOCK")     i3lock ;;
  "$ICON_LOGOUT")   i3-msg exit ;;
esac
