#!/bin/bash

analyze_logs() {
    local mode="$1"
    shift
    local pattern="$1"

    local files=()
    shopt -s nullglob
    for f in $pattern; do
        files+=("$f")
    done
    shopt -u nullglob

    if [ "${#files[@]}" -eq 0 ]; then
        echo "Error: no nginx_access_*.log files found in current directory."
        return 1
    fi

    case "$mode" in
        1)
            awk '
            {
                split($4, d, ":")
                status = $9 + 0
                print status "\t" $0
            }' "${files[@]}" | sort -n -k1,1 | cut -f2-
            ;;

        2)
            awk '{print $1}' "${files[@]}" | sort -u
            ;;

        3)
            awk '$9 ~ /^[45][0-9][0-9]$/' "${files[@]}"
            ;;

        4)
            awk '$9 ~ /^[45][0-9][0-9]$/ {print $1}' "${files[@]}" | sort -u
            ;;

        *)
            echo "Usage: $0 <mode>"
            echo "Modes:"
            echo "  1 - all records sorted by response code"
            echo "  2 - unique IP addresses"
            echo "  3 - error requests only (4xx and 5xx)"
            echo "  4 - unique IPs from error requests"
            return 1
            ;;
    esac
}
