#!/bin/bash

START_TIME=$(date +%s)

# абсолютный путь к директории текущего скрипта
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/validate.sh"
source "$SCRIPT_DIR/check_space.sh"
source "$SCRIPT_DIR/generate_names.sh"
source "$SCRIPT_DIR/log.sh"
source "$SCRIPT_DIR/create_structure.sh"
source "$SCRIPT_DIR/generate_nums.sh"

BASE_PATH=$(pwd)

if [[ "$BASE_PATH" =~ (bin|sbin) ]]; then
    echo "Error: current path contains bin or sbin: $BASE_PATH"
    exit 1
fi

FOLDER_LETTERS="$1"
FILE_PATTERN="$2"
FILE_SIZE_MB="${3%[mM][bB]*}"
DATE_SUFFIX=$(date +%d%m%y)
LOG_FILE="$BASE_PATH/generation_part2_${DATE_SUFFIX}.log"

if ! validate_params "$FOLDER_LETTERS" "$FILE_PATTERN" "$3"; then
    exit 1
fi

init_log "$LOG_FILE"

NUM_DIR_LEVELS=$(generate_num_folders)  # 1-100 уровней вложенности
NUM_FILES_MIN=1
NUM_FILES_MAX=20

echo "Creating up to $NUM_DIR_LEVELS nested folders in: $BASE_PATH" | tee -a "$LOG_FILE"

current_path="$BASE_PATH"

created_dirs=0
for ((level=1; level<=NUM_DIR_LEVELS; level++)); do
    if ! has_enough_space; then
        echo "Stopped: <1GB free on /" | tee -a "$LOG_FILE"
        break
    fi

    NUM_FILES=$(generate_num_files)  # 1-20 файлов в этой папке

    new_path=$(create_single_folder "$current_path" "$FOLDER_LETTERS" \
                                      "$DATE_SUFFIX" "$NUM_FILES" \
                                      "$FILE_PATTERN" "$FILE_SIZE_MB" \
                                      "$LOG_FILE")

    if [ $? -ne 0 ]; then   # status code is not equal "success"
        echo "create_single_folder failed at level $level" >> "$LOG_FILE"
        break
    fi

    current_path="$new_path"
    ((created_dirs++))
done

END_TIME=$(date +%s)
RUNTIME=$((END_TIME - START_TIME))

echo "=== SUMMARY ===" | tee -a "$LOG_FILE"
echo "Start: $(date -d "@$START_TIME")" | tee -a "$LOG_FILE"
echo "End: $(date -d "@$END_TIME")" | tee -a "$LOG_FILE"
echo "Runtime: ${RUNTIME}s (created $created_dirs nested folders)" | tee -a "$LOG_FILE"
