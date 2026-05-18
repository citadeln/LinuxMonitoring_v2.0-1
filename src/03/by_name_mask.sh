#!/bin/bash

match_name_mask() {
    local name="$1"
    local letters="$2"
    local date_part="$3"

    [[ "$name" =~ ^([a-z]+)_([0-9]{6})$ ]] || return 1

    local name_letters="${BASH_REMATCH[1]}"
    local name_date="${BASH_REMATCH[2]}"

    [ "$name_date" = "$date_part" ] || return 1

    local i j=0 c
    for ((i=0; i<${#letters}; i++)); do
        c="${letters:i:1}"
        while [ "$j" -lt "${#name_letters}" ] && [ "${name_letters:j:1}" != "$c" ]; do
            ((j++))
        done
        [ "$j" -lt "${#name_letters}" ] || return 1
        ((j++))
    done

    return 0
}

cleanup_by_name_mask() {
    local base_dir="$1"
    local mask letters date_part

    read -r -p "Enter mask (example: az_180526): " mask

    if ! [[ "$mask" =~ ^([a-z]{1,7})_([0-9]{6})$ ]]; then
        echo "Error: mask must be letters(1-7)_date(DDMMYY)."
        return 1
    fi

    letters="${BASH_REMATCH[1]}"
    date_part="${BASH_REMATCH[2]}"

    while IFS= read -r -d '' path; do
        local name
        name="$(basename "$path")"

        if match_name_mask "$name" "$letters" "$date_part"; then
            rm -rf "$path"
        fi
    done < <(find "$base_dir" -depth -print0)
}
