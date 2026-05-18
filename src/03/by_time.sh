#!/bin/bash

find_time_epoch() {
    local dt_str="$1"
    # convert "2026-05-18 12:00" -> seconds since epoch
    date -d "$dt_str" +%s 2>/dev/null || { echo "Invalid date string: $dt_str"; exit 1; }
}

START_EPOCH=$(find_time_epoch "$START_STR")
END_EPOCH=$(find_time_epoch "$END_STR")

if [ "$START_EPOCH" -gt "$END_EPOCH" ]; then
    echo "Start time must be earlier than or equal to end time"
    exit 1
fi

find_files_by_time_in_current_dir() {
    local base_dir
    base_dir=$(pwd)

    # walk through all files under pwd (including subdirs)
    while IFS= read -r -d '' file; do
        if [ ! -f "$file" ]; then continue; fi
        mtime=$(stat -c %Y "$file" 2>/dev/null) || continue

        if [ "$mtime" -ge "$START_EPOCH" ] && [ "$mtime" -le "$END_EPOCH" ]; then
            echo "[by_time] rm -f '$file' (mtime in [$START_STR, $END_STR])"
            rm -f "$file"
        fi
    done < <(find "$base_dir" -type f -print0 2>/dev/null)
}

find_files_by_time_in_current_dir
