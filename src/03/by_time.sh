#!/bin/bash

cleanup_by_time() {
    local base_dir="$1"
    local start_str end_str start_epoch end_epoch

    echo "Time format: YYYY-MM-DD HH:MM"
    read -r -p "Enter start time: " start_str
    read -r -p "Enter end time: " end_str

    if ! validate_time_input "$start_str" || ! validate_time_input "$end_str"; then
        echo "Error: invalid time format."
        return 1
    fi

    start_epoch=$(date -d "$start_str" +%s)
    end_epoch=$(date -d "$end_str" +%s)

    if [ "$start_epoch" -gt "$end_epoch" ]; then
        echo "Error: start time must be earlier than end time."
        return 1
    fi

    # Находим все объекты (файлы и папки) ТОЛЬКО в текущем каталоге.
    # -maxdepth 1 - не спускаться в подпапки.
    # -mindepth 1 - не трогать саму папку $base_dir.
    while IFS= read -r -d '' path; do
        local birth_epoch=$(stat -c %Y -- "$path" 2>/dev/null)

        # Проверяем, что время создания/изменения попадает в указанный диапазон
        if [ -n "$birth_epoch" ] && [ "$birth_epoch" -ge "$start_epoch" ] && [ "$birth_epoch" -le "$end_epoch" ]; then
            echo "Removing: $path"
            rm -rf -- "$path"
        fi
    done < <(find "$base_dir" -maxdepth 1 -mindepth 1 -print0)
}
