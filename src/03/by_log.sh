#!/bin/bash

prompt_log_file() {
    echo -n "Enter path to log file: "
    read -r LOG_PATH
    if [ ! -f "$LOG_PATH" ]; then
        echo "Error: log file does not exist: $LOG_PATH"
        exit 1
    fi
}

find_files_in_log_relative() {
    local log="$1"
    # ищем строки вида:
    # Created file: /path/to/..._DDMMYY.*
    # ограничиваемся только файлами внутри pwd
    local base_dir
    base_dir=$(pwd)

    grep -F "Created file:" "$log" | \
        awk '{print $3}' | \
        while read -r file; do
            if [ -n "$file" ]; then
                # нормализуем путь
                abs_file=$(readlink -f "$file" 2>/dev/null || echo "$file")
                abs_dir=$(dirname "$abs_file")

                # если base_dir == pwd, тогда удаляем
                if [ "$abs_dir" = "$base_dir" ] || \
                   [[ "$abs_dir" =~ ^"$base_dir"/ ]]; then
                    echo "[by_log] rm -f '$file'"
                    rm -f "$file"
                fi
            fi
        done
}

prompt_log_file
find_files_in_log_relative "$LOG_PATH"
