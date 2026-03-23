#!/usr/bin/env bash

OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
MUTED=$(echo "$OUTPUT" | grep -c "MUTED")
VOL=$(echo "$OUTPUT" | grep -oP '[\d.]+' | head -1)
VOL_PCT=$(echo "$VOL" | awk '{printf "%d", $1 * 100}')

ICON_VOL_DOWN=$'\uf068'
ICON_VOL_UP=$'\uf067'
ICON_TOGGLE=$([ "$MUTED" -eq 1 ] && echo $'\U000F057E' || echo $'\U000F075F')

PROMPT=$([ "$MUTED" -eq 1 ] && echo "Volume: 0%" || echo "Volume: ${VOL_PCT}%")

chosen=$(printf "%s\n%s\n%s" "$ICON_VOL_DOWN" "$ICON_TOGGLE" "$ICON_VOL_UP" \
  | rofi -dmenu -p "$PROMPT" -theme ~/.config/rofi/volume.rasi)

case "$chosen" in
  "$ICON_VOL_DOWN") wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%- ;;
  "$ICON_TOGGLE")   wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
  "$ICON_VOL_UP")   wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+ ;;
esac
