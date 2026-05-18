#!/bin/bash

validate_args() {
    local mode="$1"

    if [ -z "$mode" ]; then
        echo "Usage: $0 <mode> ; mode=1 (by_log), 2 (by_time), 3 (by_name_mask)"
        return 1
    fi

    if ! [[ "$mode" =~ ^[1-3]$ ]]; then
        echo "Error: mode must be 1, 2 or 3"
        return 1
    fi

    return 0
}
