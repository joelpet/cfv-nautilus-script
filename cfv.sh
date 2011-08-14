#!/bin/bash

function sfv_check {
    if [ -r "$1" ]; then
        if [ -d "$1" ]; then
            dirname="$1"
        elif [ -f "$1" ]; then
            dirname=$(dirname "$1")
        else
            zenity --error --text="Unknown file type: $1"
            exit 1
        fi
    else
        zenity --error --text="Read permission denied for: $1"
        exit 2
    fi

    cfv -r -s --progress no -p "$dirname" | tee /tmp/cfv.log | zenity --progress --auto-close --auto-kill --text="Checking $dirname"

    cfv_exit_status=$?
    
    if [ $cfv_exit_status -eq 0 ]; then
        info=$(cat /tmp/cfv.log)
        zenity --info --text="$info"
    else 
        zenity --error --text="cfv exited with status $?"
    fi
}

for file in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
    sfv_check $file
done
