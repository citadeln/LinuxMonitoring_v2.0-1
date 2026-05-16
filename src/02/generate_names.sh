#!/bin/bash

_build_name() {
    local letters="$1" min_len=5  # ≥5 для Part 2
    local n=${#letters}
    local target=$((n > min_len ? n + RANDOM%6 : min_len + RANDOM%6))
    
    local reps=($(printf '1 %.0s' {1..$((target-n))} | xargs -n$n))
    local name=""
    for ((i=0; i<n; i++)); do
        name+=$(printf '%*s' "${reps[i]}" "" | tr ' ' "${letters:i:1}")
    done
    echo "${name:0:10}"  # ≤10 символов
}

generate_folder_name() {
    echo "$(_build_name "$1")_${2}"
}

generate_file_name() {
    local name_part="$1" ext_part="$2" date_suf="$3"
    echo "$(_build_name "$name_part")_${date_suf}.$(_build_name "$ext_part")"
}
