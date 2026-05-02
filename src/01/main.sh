#!/bin/bash

source ./validate.sh
source ./check_space.sh
source ./generate_names.sh
source ./log.sh
source ./create_structure.sh

BASE_PATH="$1"
NUM_SUBDIRS="$2"
FOLDER_LETTERS="$3"
NUM_FILES="$4"
FILE_PATTERN="$5"
FILE_SIZE_KB="${6%[kK][bB]*}"
DATE_SUFFIX=$(date +%d%m%y)
LOG_FILE="${BASE_PATH}/generation_${DATE_SUFFIX}.log"

if ! validate_params "${@:1:5}" "$FILE_SIZE_KB"; then
    exit 1
fi

mkdir -p "$BASE_PATH" || { echo "Cannot create $BASE_PATH"; exit 1; }
init_log "$LOG_FILE"

current_path="$BASE_PATH"
for ((i=1; i<=NUM_SUBDIRS; i++)); do
    if ! has_enough_space; then
        echo "Stopped: <1GB free" | tee -a "$LOG_FILE"
        break
    fi
    
    new_path=$(create_folder_with_files "$current_path" "$FOLDER_LETTERS" "$DATE_SUFFIX" \
        "$NUM_FILES" "$FILE_PATTERN" "$FILE_SIZE_KB" "$LOG_FILE")
    [ $? -ne 0 ] && break
    current_path="$new_path"
done
