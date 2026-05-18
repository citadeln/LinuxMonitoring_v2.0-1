#!/bin/bash

match_name_mask() {
    local name="$1"
    local letters="$2"
    local date_part="$3"

    # 1. Проверяем общий формат: только буквы, затем подчеркивание, затем дата
    if ! [[ "$name" =~ ^([a-z]+)_([0-9]{6})$ ]]; then
        return 1
    fi

    local name_letters="${BASH_REMATCH[1]}"
    local name_date="${BASH_REMATCH[2]}"

    # 2. Проверяем совпадение даты
    if [ "$name_date" != "$date_part" ]; then
        return 1
    fi

    # 3. Проверка 1: Все буквы в имени должны быть из набора букв маски.
    # Если в имени найдется буква, которой нет в маске -> маска не подходит.
    for (( i=0; i<${#name_letters}; i++ )); do
        local char="${name_letters:$i:1}"
        # Проверяем, есть ли символ $char в строке $letters
        if ! [[ "$letters" == *"$char"* ]]; then
            return 1
        fi
    done

    # 4. Проверка 2: Все буквы из маски должны быть в имени (проверка покрытия).
    # Если в маске найдется буква, которой нет в имени -> маска не подходит.
    for (( i=0; i<${#letters}; i++ )); do
        local char="${letters:$i:1}"
        if ! [[ "$name_letters" == *"$char"* ]]; then
            return 1
        fi
    done

    # 5. Проверка 3: Порядок букв из маски должен сохраняться в имени.
    # (Ваша старая логика, она остается)
    local i j=0
    for (( i=0; i<${#letters}; i++ )); do
        local c="${letters:$i:1}"
        while [ "$j" -lt "${#name_letters}" ] && [ "${name_letters:$j:1}" != "$c" ]; do
            ((j++))
        done
        if [ "$j" -ge "${#name_letters}" ]; then
            return 1
        fi
        ((j++))
    done

    # Если все проверки пройдены, маска подходит.
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

    # 3) Ищем ВСЕ каталоги в текущей директории и удаляем подходящие под маску
    # -maxdepth 1 - чтобы искать только в pwd, а не во вложенных папках
    # -type d - ищем только каталоги
    # -name "*_*" - фильтруем имена с подчеркиванием для оптимизации
    local found_any=0
    while IFS= read -r -d '' folder; do
        local name="$(basename -- "$folder")"
        if match_name_mask "$name" "$letters" "$date_part"; then
            echo "Removing folder: $folder"
            rm -rf -- "$folder"
            found_any=1 # Устанавливаем флаг, что хотя бы одна папка была найдена и удалена
        fi
    done < <(find "$base_dir" -maxdepth 1 -type d -name "*_*" -print0)

    if [ "$found_any" -eq 0 ]; then
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
