#!/bin/bash

create_folder_with_files() {
    local base_path="$1" folder_letters="$2" date_suf="$3" 
    local num_files="$4" file_pat="$5" size_kb="$6" log_file="$7"
    
    local folder_name=$(generate_folder_name "$folder_letters" "$date_suf")
    local folder_path="${base_path}/${folder_name}"
    
    mkdir -p "$folder_path" && \
    echo "✓ Created: $folder_path ($(date))" >> "$log_file" || \
    { echo "✗ mkdir failed: $folder_path" >> "$log_file"; return 1; }
    
    for ((i=1; i<=num_files; i++)); do
        local fname=$(generate_file_name "${file_pat%.*}" "${file_pat#*.}" "$date_suf")
        local fpath="${folder_path}/${fname}"
        
        dd if=/dev/urandom of="$fpath" bs=1K count="$size_kb" status=none && \
        echo "✓ File: $fpath ($(date)) size=$(stat -c%s "$fpath")" >> "$log_file" || \
        echo "✗ File failed: $fpath" >> "$log_file"
    done
}
