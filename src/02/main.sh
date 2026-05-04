#!/bin/bash

START_TIME=$(date +%s)

source ./validate.sh
source ./check_space.sh
source ./generate_names.sh
source ./log.sh
source ./create_structure.sh
source ./generate_nums.sh

BASE_PATH=pwd

FOLDER_LETTERS="$1"
FILE_PATTERN="$2"
FILE_SIZE="${3%[mM][bB]*}"
DATE_SUFFIX=$(date +%d%m%y)
LOG_FILE="${BASE_PATH}/generation_${DATE_SUFFIX}.log"
NUM_FILES=$(generate_num_files)
NUM_SUBDIRS=$(generate_num_subdirs)

if ! validate_params "${@:1:5}" "$FILE_SIZE"; then
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
        "$NUM_FILES" "$FILE_PATTERN" "$FILE_SIZE" "$LOG_FILE")
    [ $? -ne 0 ] && break
    current_path="$new_path"
done


END_TIME=$(date +%s)

if ! [[ $(($END_TIME-$START_TIME)) -gt 0 ]]; then difference=$((($END_TIME-$START_TIME)*(-1)))
else difference=$(($END_TIME-$START_TIME))
fi

RUNTIME=$(($difference/1000))
echo -e "Start time: $START_TIME \n 
        End time: $END_TIME \n
        Script execution time (in seconds) = 0.$RUNTIME" | tee -a "$LOG_FILE"
