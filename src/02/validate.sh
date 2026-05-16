#!/bin/bash

validate_params() {
    if [ $# -ne 3 ]; then
        echo "Usage: $0 <folder_letters> <file_pattern> <size_Mb>"
        return 1
    fi

    local folder_letters="$1" file_pattern="$2" raw_size="$3"
    
    if [ ${#folder_letters} -gt 7 ] || [ ${#folder_letters} -eq 0 ]; then
        echo "folder_letters: 1-7 chars"; return 1
    fi
    
    IFS='.' read -ra FP <<< "$file_pattern"
    if [ ${#FP[@]} -ne 2 ] || [ ${#FP[0]} -gt 7 ] || [ ${#FP[1]} -gt 3 ]; then
        echo "file_pattern: name.ext (az.az)"; return 1
    fi
    
    local size_num="${raw_size%[mM][bB]*}"
    if ! [[ "$size_num" =~ ^[0-9]+$ ]] || [ "$size_num" -gt 100 ] || [ "$size_num" -le 0 ]; then
        echo "size_Mb: 1-100 (3Mb)"
        return 1
    fi
    
    return 0
}
