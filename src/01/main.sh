#!/bin/bash

source ./validate.sh
source ./check_space.sh
source ./generate_names.sh
source ./create_structure.sh
source ./log.sh

if ! validate_params "$@"; then
    exit 1
fi

BASE_PATH="$1"
NUM_SUBDIRS="$2"
FOLDER_LETTERS="$3"
NUM_FILES="$4"
FILE_PATTERN="$5"
FILE_SIZE_KB="$6"
DATE_SUFFIX=$(date +%d%m%y)
LOG_FILE="${BASE_PATH}/generation_${DATE_SUFFIX}.log"

init_log "$LOG_FILE"

for ((level=1; level<=NUM_SUBDIRS; level++)); do
    if ! has_enough_space "/"; then
        echo "Stopped: less than 1GB free on /" | tee -a "$LOG_FILE"
        break
    fi
    create_level "$BASE_PATH" $level "$FOLDER_LETTERS" "$DATE_SUFFIX" "$NUM_FILES" "$FILE_PATTERN" "$FILE_SIZE_KB" "$LOG_FILE"
done
