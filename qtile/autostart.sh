#!/bin/bash


# Starting picom Compositor
# picom &

# Restoring the wallpaper
nitrogen --restore &

# Running emacs daemon
/usr/bin/emacs --daemon &
