#!/bin/bash

cleanup_by_log() {
    local base_dir="$1"
    local log_file

    read -r -p "Enter log file name: " log_file

    if [ ! -f "$base_dir/$log_file" ]; then
        echo "Error: log file not found in current directory."
        return 1
    fi

    local found_any=0

    while IFS= read -r folder_path; do
        if [ -d "$folder_path" ]; then
            rm -rf -- "$folder_path"
            found_any=1
        fi
    done < <(
        sed -n 's|^Created folder: \(.*\) ([^()]*UTC)$|\1|p' "$base_dir/$log_file"
    )

    if [ "$found_any" -eq 0 ]; then
        echo "No folders or files to remove found in the log."
    fi

    if [ -f "$base_dir/$log_file" ]; then
        echo "Removing log file: $base_dir/$log_file"
        rm -f -- "$base_dir/$log_file"
    fi
}
