#!/bin/bash

# Generates a name using ONLY the given letters IN ORDER.
# Each letter is used at least once. Total length is randomly chosen
# between min_len and max_len. No trimming — avoids dropping letters.
_build_name() {
    local letters="$1"
    local min_len="$2"
    local max_len="${3:-15}"
    local n=${#letters}

    # Effective bounds: can't be shorter than number of letters
    local eff_min=$(( min_len > n ? min_len : n ))
    local eff_max=$(( max_len > n ? max_len : n ))
    [ "$eff_min" -gt "$eff_max" ] && eff_min="$eff_max"

    # Pick a random total length in [eff_min, eff_max]
    local span=$(( eff_max - eff_min ))
    local target=$(( eff_min + RANDOM % (span + 1) ))

    # Each letter gets at least 1 rep; distribute remaining chars randomly
    local -a reps
    for ((i = 0; i < n; i++)); do reps[i]=1; done

    local extra=$(( target - n ))
    for ((r = 0; r < extra; r++)); do
        local pos=$(( RANDOM % n ))
        reps[pos]=$(( reps[pos] + 1 ))
    done

    # Build the name in order
    local name=""
    for ((i = 0; i < n; i++)); do
        local c="${letters:$i:1}"
        for ((j = 0; j < reps[i]; j++)); do name+="$c"; done
    done

    echo "$name"
}

generate_folder_name() {
    local letters="$1" date_suf="$2"
    # min 4 chars, max 10 — gives good variety for uniqueness
    echo "$(_build_name "$letters" 4 10)_${date_suf}"
}

generate_file_name() {
    local name_part="$1" ext_part="$2" date_suf="$3"
    local name_body ext_body
    # File name: min 4, max 7
    name_body=$(_build_name "$name_part" 4 7)
    # Extension: each letter used at least once, max 3 chars
    # min = number of ext letters (e.g. "fgh" → min 3, max 3 → always "fgh" variants)
    ext_body=$(_build_name "$ext_part" "${#ext_part}" 3)
    echo "${name_body}_${date_suf}.${ext_body}"
}
