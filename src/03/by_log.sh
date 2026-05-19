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
        folder_path=${folder_path%% (*}
        folder_name="${folder_path##*/}"

        if [ -d "$base_dir/$folder_name" ]; then
            rm -rf -- "$base_dir/$folder_name"
            found_any=1
        fi
    done < <(awk -F': ' '/^Created folder: / {print $2}' "$base_dir/$log_file")

    while IFS= read -r file_path; do
        file_path=${file_path%% (*}
        file_name="${file_path##*/}"

        if [ -f "$base_dir/$file_name" ]; then
            rm -f -- "$base_dir/$file_name"
            found_any=1
        fi
    done < <(awk -F': ' '/^Created file: / {print $2}' "$base_dir/$log_file")

    if [ "$found_any" -eq 0 ]; then
        echo "No folders or files to remove found in the log."
    fi

    if [ -f "$base_dir/$log_file" ]; then
        echo "Removing log file: $base_dir/$log_file"
        rm -f -- "$base_dir/$log_file"
    fi
}
