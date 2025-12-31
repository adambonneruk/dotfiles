#!/bin/bash

# toast notification
notify-send "1Password" "Password put on clipboard, it will be cleared in 45 seconds"

# pipe pass-show to clipboard
: '
  pass show 1password | xclip -selection clipboard
  pass show 1pw/master | wl-copy
 '
pass show 1password -c

# sleep for 5 seconds
: '
  sleep 5
 '

# clear clipboard
: '
  wl-copy --clear
  printf "" | xclip -selection clipboard
 '

