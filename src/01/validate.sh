#!/bin/bash

validate_params() {
    if [ $# -ne 6 ]; then
        echo "Usage: $0 <path> <num_subdirs> <folder_letters> <num_files> <file_pattern> <size_kb>"
        return 1
    fi
    BASE_PATH="$1"
    if ! [[ "$2" =~ ^[0-9]+$ ]] || [ "$2" -le 0 ]; then echo "num_subdirs must be positive int"; return 1; fi
    if [ ${#3} -gt 7 ] || [ ${#3} -eq 0 ]; then echo "folder_letters: 1-7 chars"; return 1; fi
    if ! [[ "$4" =~ ^[0-9]+$ ]] || [ "$4" -le 0 ]; then echo "num_files must be positive int"; return 1; fi
    IFS='.' read -ra FP <<< "$5"
    if [ ${#FP[@]} -ne 2 ] || [ ${#FP[0]} -gt 7 ] || [ ${#FP[0]} -eq 0 ] || [ ${#FP[1]} -gt 3 ] || [ ${#FP[1]} -eq 0 ]; then
        echo "file_pattern: name<=7.ext<=3 letters"; return 1
    fi
    if ! [[ "$6" =~ ^[0-9]+$ ]] || [ "$6" -gt 100 ] || [ "$6" -le 0 ]; then echo "size_kb: 1-100"; return 1; fi
    mkdir -p "$BASE_PATH" 2>/dev/null || { echo "Invalid path"; return 1; }
    return 0
}
