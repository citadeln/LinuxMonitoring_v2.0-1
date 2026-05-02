#!/bin/bash

_build_name() {
    local letters="$1" min_len="$2" max_len="$3"
    local n=${#letters}

    # Определение реальной минимальной длины: либо 4 (по условию), либо кол-во букв — что больше
    local lo=$min_len
    (( n > lo )) && lo=$n

    # Здесь вычисляется финальная длина строки
    local target=$(( lo + RANDOM % (max_len - lo + 1) ))

    local -a reps   # repetitions
    for ((i = 0; i < n; i++)); do reps[i]=1; done
    for ((r = n; r < target; r++)); do
        local pos=$(( RANDOM % n ))
        reps[$pos]=$(( reps[$pos] + 1 ))
    done

    local name=""
    for ((i = 0; i < n; i++)); do
        local c="${letters:$i:1}"   # Здесь мы берем из строки letters (az) символ, начиная с позиции $i, длиной в 1 символ
        for ((j = 0; j < reps[i]; j++)); do name+="$c"; done
    done
    echo "$name"
}

generate_folder_name() {
    local letters="$1" date_suf="$2"
    echo "$(_build_name "$letters" 4 10)_${date_suf}"
}

generate_file_name() {
    local name_part="$1" ext_part="$2" date_suf="$3"
    local name_body ext_body
    name_body=$(_build_name "$name_part" 4 7)
    ext_body=$(_build_name "$ext_part" "${#ext_part}" 3)
    echo "${name_body}_${date_suf}.${ext_body}"
}
