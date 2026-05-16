#!/bin/bash

_build_name() {
    local letters="$1" min_len=5 max_len=10

    local n=${#letters}
    local lo=$((min_len > n ? min_len : n))
    local target=$((lo + RANDOM % (max_len - lo + 1)))

    local -a reps
    for ((i=0; i<n; i++)); do
        reps[i]=1
    done
    for ((r=n; r<target; r++)); do
        local pos=$((RANDOM % n))
        reps[pos]=$((${reps[pos]} + 1))
    done

    local name=""
    for ((i=0; i<n; i++)); do
        local c="${letters:$i:1}"
        for ((j=0; j<${reps[i]}; j++)); do
            name="${name}${c}"
        done
    done

    echo "$name"
}

generate_folder_name() {
    local letters="$1" date_suf="$2"
    echo "$(_build_name "$letters")_${date_suf}"
}

generate_file_name() {
    local name_part="$1" ext_part="$2" date_suf="$3"
    local name_body="$(_build_name "$name_part")"
    local ext_body="$(_build_name "$ext_part")"
    echo "${name_body}_${date_suf}.${ext_body}"
}
