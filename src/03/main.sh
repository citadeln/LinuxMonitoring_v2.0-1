#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(pwd)"

source "$SCRIPT_DIR/validate.sh"

echo "Choose cleanup method:"
echo "1) By log file"
echo "2) By creation time"
echo "3) By name mask"
echo

read -r -p "Enter your choice (1-3): " MODE

if ! validate_mode "$MODE"; then
    exit 1
fi

case "$MODE" in
    1) source "$SCRIPT_DIR/by_log.sh"; cleanup_by_log "$BASE_DIR" ;;
    2) source "$SCRIPT_DIR/by_time.sh"; cleanup_by_time "$BASE_DIR" ;;
    3) source "$SCRIPT_DIR/by_name_mask.sh"; cleanup_by_name_mask "$BASE_DIR" ;;
esac

echo "=== Cleanup have done ==="
