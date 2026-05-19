#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_PATH="$(pwd)"

if [[ "$BASE_PATH" =~ (bin|sbin) ]]; then
    echo "Error: current path contains bin or sbin: $BASE_PATH"
    exit 1
fi

source "$SCRIPT_DIR/generate_logs.sh"

generate_logs "$BASE_PATH"
