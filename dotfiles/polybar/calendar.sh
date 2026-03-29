#!/usr/bin/env bash

current_day=$(date +"%e" | tr -d ' ')
current_month=$(date +"%-m")
current_year=$(date +"%Y")

MONTH=$(date +"%-m")
YEAR=$(date +"%Y")

previous_month="◀"
next_month="▶"
last_selected_option=""

parse_days() {
    cal "$1" "$2" | tail -n +3 | while IFS= read -r line; do
        for col in 0 3 6 9 12 15 18; do
            day="${line:$col:2}"
            day=$(echo "$day" | tr -d ' ')
            if [ -z "$day" ]; then
                echo "."
            else
                echo "$day"
            fi
        done
    done
}

build_grid() {
    local days
    days=$(parse_days "$MONTH" "$YEAR")

    # Weekday abbreviations
    local -a wkdays
    IFS=$'\n' read -r -d '' -a wkdays < <(cal "$MONTH" "$YEAR" | sed -n '2p' | sed 's/  */ /g;s/^ //;s/ $//' | tr ' ' '\n' && printf '\0')

    # Read days into array
    local -a day_arr
    IFS=$'\n' read -r -d '' -a day_arr < <(echo "$days" && printf '\0')

    # Pad to 42 days (6 weeks)
    while [ ${#day_arr[@]} -lt 42 ]; do
        day_arr+=(".")
    done

    # Build 7-row x 9-col grid in row-major order
    # Row 0: ◀ wk0 wk1 wk2 wk3 wk4 wk5 wk6 ▶
    # Row 1-6: . day0 day1 day2 day3 day4 day5 day6 .
    local -a grid
    # Row 0
    grid[0]="$previous_month"
    for i in $(seq 0 6); do
        grid[$((i + 1))]="${wkdays[$i]}"
    done
    grid[8]="$next_month"

    # Rows 1-6
    for row in $(seq 0 5); do
        local base=$((9 + row * 9))
        grid[$base]="."
        for col in $(seq 0 6); do
            grid[$((base + col + 1))]="${day_arr[$((row * 7 + col))]}"
        done
        grid[$((base + 8))]="."
    done

    # Now transpose: rofi fills columns top-to-bottom
    # grid[row*9+col] -> output at col*7+row (for 7 rows, 9 cols)
    local rows=7 cols=9
    for c in $(seq 0 $((cols - 1))); do
        for r in $(seq 0 $((rows - 1))); do
            echo "${grid[$((r * cols + c))]}"
        done
    done
}

# Map from row-major index to column-major index (what rofi uses)
rowmajor_to_colmajor() {
    local idx=$1 rows=7 cols=9
    local row=$((idx / cols))
    local col=$((idx % cols))
    echo $((col * rows + row))
}

calendar_menu() {
    local header
    header=$(cal "$MONTH" "$YEAR" | head -1 | sed 's/^ *//;s/ *$//')

    local grid_output
    grid_output=$(build_grid)

    # Arrows: row-major 0 and 8 -> column-major
    local prev_idx=$(rowmajor_to_colmajor 0)
    local next_idx=$(rowmajor_to_colmajor 8)
    local urgent="-u $prev_idx,$next_idx"
    local active=""
    local selected_row=""

    if [ "$current_month" -eq "$MONTH" ] && [ "$current_year" -eq "$YEAR" ]; then
        # Find today in the day cells (rows 1-6, cols 1-7)
        local days
        days=$(parse_days "$MONTH" "$YEAR")
        local -a day_arr
        IFS=$'\n' read -r -d '' -a day_arr < <(echo "$days" && printf '\0')

        for i in "${!day_arr[@]}"; do
            if [ "${day_arr[$i]}" = "$current_day" ]; then
                local row=$(( i / 7 + 1 ))
                local col=$(( i % 7 + 1 ))
                local rm_idx=$(( row * 9 + col ))
                local cm_idx=$(rowmajor_to_colmajor $rm_idx)
                active="-a $cm_idx"
                selected_row="-selected-row $cm_idx"
                break
            fi
        done
    fi

    if [ "$last_selected_option" = "$previous_month" ]; then
        selected_row="-selected-row $prev_idx"
    fi
    if [ "$last_selected_option" = "$next_month" ]; then
        selected_row="-selected-row $next_idx"
    fi

    echo "$grid_output" | rofi -dmenu -no-config \
        -theme ~/.config/rofi/calendar.rasi \
        -p "$header" $urgent $active $selected_row
}

while true; do
    selected=$(calendar_menu)
    last_selected_option="$selected"
    case "$selected" in
        "$previous_month")
            MONTH=$((MONTH - 1))
            if [ "$MONTH" -lt 1 ]; then
                MONTH=12
                YEAR=$((YEAR - 1))
            fi
            ;;
        "$next_month")
            MONTH=$((MONTH + 1))
            if [ "$MONTH" -gt 12 ]; then
                MONTH=1
                YEAR=$((YEAR + 1))
            fi
            ;;
        *)
            break
            ;;
    esac
done
