#!/bin/bash

cleanup_by_log() {
    local base_dir="$1"
    local log_file

    read -r -p "Enter log file name: " log_file

    if [ ! -f "$base_dir/$log_file" ]; then
        echo "Error: log file not found in current directory."
        return 1
    fi

    local folder_path
    folder_path=$(awk -F'Created folder: ' '/^Created folder: / {print $2; exit}' "$base_dir/$log_file" | awk '{
        sub(/ \(.*/, "", $0);
        print
    }')

    if [ -z "$folder_path" ]; then
        echo "Error: no folder entries found in log."
        return 1
    fi

    if [ ! -e "$folder_path" ]; then
        return 0
    fi

    rm -rf "$folder_path"
}
