#!/usr/bin/env bash
echo $1
if [ $# -eq 0 ]; then
    killall clipse
    alacritty --class clipse -e 'clipse'
fi
if [ $1 == "d" ]; then
    clipse -clear
fi
if [ $1 == "w" ]; then
    clipse -clear
fi
