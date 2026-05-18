#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/validate.sh"

MODE="$1"

if ! validate_args "$MODE"; then
    exit 1
fi

case "$MODE" in
    1)  # по лог-файлу
        echo "=== Delete by log file (relative to current dir) ==="
        source "$SCRIPT_DIR/by_log.sh"
        ;;
    2)  # по дате и времени
        echo "=== Delete by creation time (relative to current dir) ==="
        source "$SCRIPT_DIR/by_time.sh"
        ;;
    3)  # по маске имени
        echo "=== Delete by name mask (relative to current dir) ==="
        source "$SCRIPT_DIR/by_name_mask.sh"
        ;;
    *)  echo "Invalid mode: use 1, 2 or 3"; exit 1 ;;
esac
