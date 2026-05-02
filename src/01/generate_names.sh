#!/bin/bash

generate_folder_name() {
    local letters="$1" date_suf="$2"
    local name="$letters"  # kl
    while [ ${#name} -lt 4 ]; do name+="kl"; done
    echo "${name}_${date_suf}"
}

generate_file_name() {
    local name_part="$1" ext_part="$2" date_suf="$3"
    
    # Генерируем короткую часть имени (2-4 символа) из набора букв, сохраняя порядок набора
    # Используем 'shuf' для перемешивания букв из набора и берем первые N
    local name_len=$((RANDOM % 3 + 2)) # Длина 2-4
    local name_body=$(echo "$name_part" | fold -w1 | shuf | tr -d '\n' | head -c "$name_len")
    
    # Генерируем короткое расширение (1-2 символа)
    local ext_len=$((RANDOM % 2 + 1))
    local ext_body=$(echo "$ext_part" | fold -w1 | shuf | tr -d '\n' | head -c "$ext_len")
    
    echo "${name_body}_${date_suf}.${ext_body}"
}
