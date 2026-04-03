#!/usr/bin/env bash

ICON_MUTED=$'\U000F075E'
ICON_VOL=$'\U000F057E'

OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
MUTED=$(echo "$OUTPUT" | grep -c "MUTED")
VOL=$(echo "$OUTPUT" | grep -oP '[\d.]+' | head -1)
VOL_PCT=$(echo "$VOL" | awk '{printf "%3d", $1 * 100}')

source "$HOME/.config/theme/active/colors.sh"
BG_HL="$THEME_BG_HL"
GREEN="$THEME_GREEN"
RED="$THEME_RED"

if [ "$MUTED" -eq 1 ]; then
  echo "%{B${BG_HL}}%{u${RED}}%{+u} %{T2}${ICON_MUTED} %{T-}  0% %{-u}%{B-}"
else
  echo "%{B${BG_HL}}%{u${GREEN}}%{+u} %{T2}${ICON_VOL} %{T-}${VOL_PCT}% %{-u}%{B-}"
fi
