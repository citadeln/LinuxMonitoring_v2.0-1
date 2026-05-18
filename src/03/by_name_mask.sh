#!/bin/bash

match_name_mask() {
    local name="$1"
    local letters="$2"
    local date_part="$3"

    # Проверяем формат: буквы_дата
    [[ "$name" =~ ^([a-z]+)_([0-9]{6})$ ]] || return 1

    local name_letters="${BASH_REMATCH[1]}"
    local name_date="${BASH_REMATCH[2]}"

    # Проверяем совпадение даты
    [ "$name_date" = "$date_part" ] || return 1

    # Проверяем порядок букв из маски в имени (каждая буква маски должна встречаться в имени по порядку)
    local i j=0 c
    for ((i=0; i<${#letters}; i++)); do
        c="${letters:i:1}"
        while [ "$j" -lt "${#name_letters}" ] && [ "${name_letters:j:1}" != "$c" ]; do ((j++)); done
        [ "$j" -lt "${#name_letters}" ] || return 1
        ((j++))
    done

    return 0
}

cleanup_by_name_mask() {
    local base_dir="$1"
    local mask letters date_part

    # 1) Запрашиваем маску у пользователя
    read -r -p "Enter mask (example: az_180526): " mask

    # 2) Валидируем формат маски (буквы_дата)
    if ! [[ "$mask" =~ ^([a-z]{1,7})_([0-9]{6})$ ]]; then
        echo "Error: mask must be letters(1-7)_date(DDMMYY)."
        return 1
    fi

    letters="${BASH_REMATCH[1]}"
    date_part="${BASH_REMATCH[2]}"

    # 3) Ищем ТОЛЬКО ПЕРВЫЙ каталог, СООТВЕТСТВУЮЩИЙ МАСКЕ, в текущей директории (не рекурсивно)
    # -maxdepth 1 - чтобы искать только в pwd, а не во вложенных папках
    # -type d - ищем только каталоги
    # -name "*_*" - фильтруем имена с подчеркиванием для оптимизации
    local found_folder=
    while IFS= read -r -d '' folder; do
        local name="$(basename -- "$folder")"
        if match_name_mask "$name" "$letters" "$date_part"; then
            found_folder="$folder"
            break # Нашли первую подходящую папку, выходим из цикла
        fi
    done < <(find "$base_dir" -maxdepth 1 -type d -name "*_*" -print0)

    if [ -n "$found_folder" ] && [ -d "$found_folder" ]; then
        echo "Found matching folder: $found_folder"
        echo "Removing folder and all its contents..."
        rm -rf -- "$found_folder"
    else
        echo "No matching folders found in current directory."
    fi

    # 4) Удаляем лог-файл, соответствующий этой дате
    local log_file_to_delete="${base_dir}/generation_part2_${date_part}.log"
    if [ -f "$log_file_to_delete" ]; then
        echo "Removing log file: $log_file_to_delete"
        rm -f -- "$log_file_to_delete"
    else
        echo "Log file $log_file_to_delete not found."
    fi
}
