#!/bin/bash

create_folder_with_files() {
    local base_path="$1" folder_letters="$2" date_suf="$3"
    local num_files="$4" file_pat="$5" size_kb="$6" log_file="$7"

    # Find a unique folder name inside base_path
    local folder_name folder_path tries=0
    while true; do
        folder_name=$(generate_folder_name "$folder_letters" "$date_suf")
        folder_path="${base_path}/${folder_name}"
        [ ! -d "$folder_path" ] && break
        tries=$(( tries + 1 ))
        if [ "$tries" -ge 10000 ]; then
            echo "✗ Cannot generate unique folder name (letter set too small)" >> "$log_file"
            return 1
        fi
    done

    mkdir -p "$folder_path" && \
        echo "✓ Created: $folder_path ($(date))" >> "$log_file" || \
        { echo "✗ mkdir failed: $folder_path" >> "$log_file"; return 1; }

    for ((i=1; i<=num_files; i++)); do
        local fname fpath file_tries=0
        while true; do
            fname=$(generate_file_name "${file_pat%.*}" "${file_pat#*.}" "$date_suf")
            fpath="${folder_path}/${fname}"
            [ ! -e "$fpath" ] && break
            file_tries=$(( file_tries + 1 ))
            if [ "$file_tries" -ge 10000 ]; then
                echo "✗ Cannot generate unique file name (letter set too small)" >> "$log_file"
                return 1
            fi
        done

        dd if=/dev/urandom of="$fpath" bs=1K count="$size_kb" status=none && \
            echo "✓ File: $fpath ($(date)) size=$(stat -c%s "$fpath")" >> "$log_file" || \
            echo "✗ File failed: $fpath" >> "$log_file"
    done

    # Output the created folder path — main.sh captures this for the next nesting level
    echo "$folder_path"
}
