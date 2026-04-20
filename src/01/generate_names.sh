#!/bin/bash

generate_folder_name() {
    local letters="$1" date_suf="$2"
    local name=""
    local counts=()
    for ((i=0; i<${#letters}; i++)); do counts[i]=1; done  # min 1 each
    # Генерация: базовая с +a/z... до len>=4
    for len in {4..10}; do  # примерный диапазон
        name=$(printf '%*s' "$len" | tr ' ' "${letters:0:1}")  # start with first letter repeats
        for ((pos=1; posen; pos++)); do
            rand_letter=${letters:$((RANDOM % ${#letters})):1}
            name+="$rand_letter"
        done
        # Проверка: все буквы использованы хотя бы раз (улучшить с grep -o | sort | uniq)
        if [[ $(echo "$name" | grep -o . | sort -u | tr -d '\n' | grep -q "^${letters}$" ]]; then
            echo "${name}_${date_suf}"
            return
        fi
    done
}

generate_file_name() {
    local name_part="$1" ext_part="$2" date_suf="$3"
    name=$(generate_folder_name "$name_part" "")  # reuse logic
    ext=$(generate_folder_name "$ext_part" "")
    echo "${name}_${date_suf}.${ext}"
}
