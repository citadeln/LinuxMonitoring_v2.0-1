#!/bin/bash

source ./check_space.sh
source ./generate_names.sh

create_level() {
    local current_path="$1" 
    local level="$2" 
    local folder_letters="$3" 
    local date_suf="$4" 
    local num_files="$5" 
    local file_pat="$6" 
    local size_kb="$7" 
    local log="$8"
    
    # Генерируем имя текущей папки
    local folder_name=$(generate_folder_name "$folder_letters" "$date_suf")
    local new_path="${current_path}/${folder_name}"
    
    mkdir -p "$new_path" || return 1
    log_entry "$log" "Created folder: $new_path $(date)"
    
    # Создаем файлы в текущей созданной папке
    for ((i=1; i<=num_files; i++)); do
        if ! has_enough_space "/"; then return 1; fi
        
        local fname=$(generate_file_name "${file_pat%.*}" "${file_pat#*.}" "$date_suf")
        local fpath="${new_path}/${fname}"
        
        dd if=/dev/urandom of="$fpath" bs=1K count="$size_kb" status=none 2>/dev/null
        log_entry "$log" "Created file: $fpath $(date) $(stat -c%s "$fpath" 2>/dev/null || echo 'unknown')"
    done

    # РЕКУРСИЯ: если это не последний уровень, вызываем функцию для вложенной папки
    # Здесь нужно добавить логику контроля глубины, если вы хотите ограничить вложенность
}
