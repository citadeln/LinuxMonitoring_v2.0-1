#!/bin/bash

validate_params() {
    if [ $# -ne 6 ]; then
        echo "Usage: $0 <path> <num_subdirs> <folder_letters> <num_files> <file_pattern> <size_Mb>"
        return 1
    fi

    if [[ ! "$1" =~ ^/.*$ ]]; then echo "Path must be absolute (start with /)"; return 1; fi

    if ! [[ "$2" =~ ^[0-9]+$ ]] || [ "$2" -le 0 ]; then echo "num_subdirs must be positive int"; return 1; fi
    
    if [ ${#3} -gt 7 ] || [ ${#3} -eq 0 ]; then echo "folder_letters: 1-7 chars"; return 1; fi

    if ! [[ "$4" =~ ^[0-9]+$ ]] || [ "$4" -le 0 ]; then echo "num_files must be positive int"; return 1; fi

    IFS='.' read -ra FP <<< "$5"
    if [ ${#FP[@]} -ne 2 ] || [ ${#FP[0]} -gt 7 ] \
        || [ ${#FP[0]} -eq 0 ] || [ ${#FP[1]} -gt 3 ] \
        || [ ${#FP[1]} -eq 0 ]; then
        echo "file_pattern: name<=7, .ext<=3 letters (e.g., sdf.az)"; return 1
    fi

    local raw_size="$6"
    local size_num

    if [[ "$raw_size" =~ ^[0-9]+[mM][bB]$ ]]; then
        size_num="${raw_size%[mM][mM]*}"
    elif [[ "$raw_size" =~ ^[0-9]+$ ]]; then
        size_num="$raw_size"
    else
        echo "size_Mb: must be a number or number followed by 'Mb' (e.g., 10 or 10Mb)"
        return 1
    fi

    # Проверяем диапазон числа
    if [ "$size_num" -gt 100 ] || [ "$size_num" -le 0 ]; then
        echo "size_Mb: value must be between 1 and 100"
        return 1
    fi

    return 0
}
