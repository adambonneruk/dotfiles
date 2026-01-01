#!/usr/bin/env bash

FONT="big"        # try: big, digital, lean, mono12
LOW=25
MID=50
HI=80

# --- terminal setup ---
orig_stty=$(stty -g)

tput smcup        # alternate screen
tput civis        # hide cursor
stty -echo -icanon

cleanup() {
  stty "$orig_stty"
  tput rmcup
  tput cnorm
  tput sgr0
  exit
}
trap cleanup INT TERM

# --- state ---
last_percent=""
last_cols=0
last_rows=0
need_redraw=1

trap 'need_redraw=1' SIGWINCH

blank_screen() {
  local cols rows r
  cols=$(tput cols)
  rows=$(tput lines)
  for ((r=0; r<rows; r++)); do
    tput cup "$r" 0
    printf "%-${cols}s" ""
  done
}

while true; do
  # ---- quit key ----
  if read -rsn1 -t 0.1 key; then
    [[ $key == "q" ]] && cleanup
  fi

  percent=$(acpi -b | awk -F', ' '{print $2}' | tr -d '%')
  cols=$(tput cols)
  rows=$(tput lines)

  # ---- redraw only if needed ----
  if [[ "$percent" != "$last_percent" ]] ||
     (( cols != last_cols )) ||
     (( rows != last_rows )) ||
     (( need_redraw )); then

    need_redraw=0
    last_percent="$percent"
    last_cols=$cols
    last_rows=$rows

    # color selection
    if (( percent < LOW )); then
      color="\e[31m"   # red
    elif (( percent < MID )); then
      color="\e[33m"   # yellow
    elif (( percent < HI )); then
      color="\e[32m"   # green
    else
      color="\e[31m"   # red
    fi

    mapfile -t lines_arr < <(figlet -f "$FONT" "${percent}%")

    text_width=$(printf "%s\n" "${lines_arr[@]}" \
                  | awk '{print length}' \
                  | sort -nr | head -1)
    text_height=${#lines_arr[@]}

    # ---- centering (visual bias +1 row) ----
    start_col=$(( (cols - text_width) / 2 ))
    start_row=$(( (rows - text_height) / 2 + 1 ))

    (( start_col < 0 )) && start_col=0
    (( start_row < 0 )) && start_row=0

    # ---- full blank once per redraw ----
    blank_screen

    # ---- draw ----
    for i in "${!lines_arr[@]}"; do
      tput cup $(( start_row + i )) "$start_col"
      printf "%b%s%b" "$color" "${lines_arr[i]}" "\e[0m"
    done
  fi

  sleep 0.1
done

