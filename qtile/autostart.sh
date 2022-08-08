#!/bin/bash


# Starting picom Compositor
picom &

# Running emacs daemon
/usr/bin/emacs --daemon &

# Restoring the wallpaper
nitrogen --restore & 
