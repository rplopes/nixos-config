#!/usr/bin/env bash

ICON_DARK=$'\uf186'
ICON_LIGHT=$'\uf185'

current=$(basename "$(readlink "$HOME/.config/theme/active")")
if [[ "$current" == *"light"* ]]; then
    echo "%{T2}${ICON_LIGHT}%{T-}"
else
    echo "%{T2}${ICON_DARK}%{T-}"
fi
