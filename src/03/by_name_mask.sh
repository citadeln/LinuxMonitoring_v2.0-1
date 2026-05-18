#!/bin/bash

prompt_name_mask() {
    echo -n "Enter name mask (e.g., aaaz_021121.*): "
    read -r MASK
    if [ -z "$MASK" ]; then
        echo "Mask cannot be empty"
        exit 1
    fi
}

find_files_by_name_mask_in_current_dir() {
    local base_dir
    base_dir=$(pwd)

    while IFS= read -r -d '' file; do
        if [ -f "$file" ] && [[ "$file" =~ $MASK ]]; then
            echo "[by_name_mask] rm -f '$file'"
            rm -f "$file"
        fi
    done < <(find "$base_dir" -type f -print0 2>/dev/null)
}

prompt_name_mask
find_files_by_name_mask_in_current_dir
