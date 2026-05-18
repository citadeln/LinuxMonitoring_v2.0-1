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

    # 3) Ищем первую строку с "Created folder:" и извлекаем путь к папке
    # awk выводит только первый найденный путь (exit после первого совпадения)
    local first_folder_path
    first_folder_path=$(awk '/^Created folder: / {print $NF; exit}' "$base_dir/$log_file")

    # 4) Проверяем, что путь был найден
    if [ -z "$first_folder_path" ]; then
        echo "Error: no folder entries found in log."
        return 1
    fi

    # 5) Проверяем, что папка существует, и удаляем её рекурсивно
    if [ -d "$first_folder_path" ]; then
        echo "Removing folder: $first_folder_path"
        rm -rf -- "$first_folder_path"
    else
        echo "Warning: folder '$first_folder_path' not found. Nothing to remove."
    fi

    # 6) Удаляем сам лог-файл, если он существует
    if [ -f "$base_dir/$log_file" ]; then
        echo "Removing log file: $base_dir/$log_file"
        rm -f -- "$base_dir/$log_file"
    fi
}
