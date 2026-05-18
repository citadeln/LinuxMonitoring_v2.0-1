#!/bin/bash

validate_mode() {
    local mode="$1"

    if ! [[ "$mode" =~ ^[1-3]$ ]]; then
        echo "Error: choose 1, 2 or 3."
        return 1
    fi

    return 0
}

validate_time_input() {
    local value="$1"

    if ! [[ "$value" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]][0-9]{2}:[0-9]{2}$ ]]; then
        return 1
    fi

    date -d "$value" >/dev/null 2>&1
}
