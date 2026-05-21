#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_PATH="$(pwd)"

if [[ "$BASE_PATH" =~ (bin|sbin) ]]; then
    echo "Error: current path contains bin or sbin: $BASE_PATH"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mode>"
    echo "Modes:"
    echo "  1 - all records sorted by response code"
    echo "  2 - unique IP addresses"
    echo "  3 - error requests only (4xx and 5xx)"
    echo "  4 - unique IPs from error requests"
    exit 1
fi

MODE="$1"
LOG_PATTERN="$BASE_PATH"/nginx_access_*.log

source "$SCRIPT_DIR/analyze_logs.sh"

analyze_logs "$MODE" "$LOG_PATTERN"
