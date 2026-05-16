#!/bin/bash

create_single_folder() {
    local base_path="$1" folder_letters="$2" date_suf="$3"
    local num_files="$4" file_pat="$5" size_mb="$6" log_file="$7"

    local folder_name=$(generate_folder_name "$folder_letters" "$date_suf")
    local folder_path="$base_path/$folder_name"

    mkdir -p "$folder_path" && \
        echo "Created folder: $folder_path ($(date))" >> "$log_file" || \
        echo "mkdir failed: $folder_path" >> "$log_file"

    for ((i=1; i<=num_files; i++)); do
        if ! has_enough_space; then
            echo "Stopped: <1GB free on / (creating files)" | tee -a "$log_file"
            break
        fi

        local fname=$(generate_file_name "${file_pat%.*}" "${file_pat#*.}" "$date_suf")
        local fpath="$folder_path/$fname"

        # создаём файл заданного размера в Мегабайтах
        dd if=/dev/urandom of="$fpath" bs=1M count="$size_mb" status=none && \
            echo "Created file: $fpath ($(date)) $(stat -c%s "$fpath") bytes" >> "$log_file" || \
            echo "Failed to create file: $fpath" >> "$log_file"
    done

    # возвращаем путь следующей папки для вложенности
    echo "$folder_path"
}
