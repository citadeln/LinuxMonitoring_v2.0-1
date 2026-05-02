#!/bin/bash

generate_folder_name() {
    local letters="$1" date_suf="$2"
    local base="$letters"  # az
    while [ ${#base} -lt 4 ]; do base+="${letters:0:1}"; done  # aaaz
    echo "${base}_${date_suf}"
}

generate_file_name() {
    local name_part="$1" ext_part="$2" date_suf="$3"
    local name_len=$((RANDOM % 4 + 4))
    local name_body=$(cat /dev/urandom | tr -dc "$name_part" | head -c "$name_len")
    
    local ext_len=$((RANDOM % 3 + 1))
    local ext_body=$(cat /dev/urandom | tr -dc "$ext_part" | head -c "$ext_len")
    
    # Проверка для имени файла тоже
    local used_name=$(echo "$name_body" | grep -o . | sort -u | tr -d '\n')
    [[ "$used_name" != "$name_part" ]] && name_body=$(generate_folder_name "$name_part" "") && name_body="${name_body%_*}"
    
    echo "${name_body}_${date_suf}.${ext_body}"
}
