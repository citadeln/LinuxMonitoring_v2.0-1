#!/bin/bash

cleanup_by_log() {
    local base_dir="$1"
    local log_file

    # 1) Запрашиваем имя лог-файла
    read -r -p "Enter log file name: " log_file

    # 2) Проверяем существование файла
    if [ ! -f "$base_dir/$log_file" ]; then
        echo "Error: log file not found in current directory."
        return 1
    fi

    local found_any=0

    # 3) Находим ВСЕ пути к папкам, упомянутым в логе, и удаляем их
    # Используем цикл while с process substitution для безопасного чтения строк
    # Мы ищем строки, начинающиеся с "Created folder: "
    while IFS= read -r folder_path; do
        # Проверяем, что это существующая папка
        if [ -d "$folder_path" ]; then
            echo "Removing folder: $folder_path"
            rm -rf -- "$folder_path"
            found_any=1
        else
            # Если папки нет (например, уже удалена), просто выводим предупреждение
            echo "Warning: folder '$folder_path' not found. Skipping."
        fi
    done < <(awk '/^Created folder: / {print $NF}' "$base_dir/$log_file")

    # 4) Находим ВСЕ пути к файлам, упомянутым в логе, и удаляем их
    while IFS= read -r file_path; do
        if [ -f "$file_path" ]; then
            echo "Removing file: $file_path"
            rm -f -- "$file_path"
            found_any=1
        fi
    done < <(awk '/^Created file: / {print $NF}' "$base_dir/$log_file")

    if [ "$found_any" -eq 0 ]; then
        echo "No folders or files to remove found in the log."
    fi

    # 5) Удаляем сам лог-файл, если он существует
    if [ -f "$base_dir/$log_file" ]; then
        echo "Removing log file: $base_dir/$log_file"
        rm -f -- "$base_dir/$log_file"
    fi
}
