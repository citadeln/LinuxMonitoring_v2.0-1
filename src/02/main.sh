#!/bin/bash

START_TIME=$(date +%s)

source ./validate.sh
source ./check_space.sh
source ./generate_names.sh
source ./log.sh
source ./generate_nums.sh

FOLDER_LETTERS="$1"
FILE_PATTERN="$2"
FILE_SIZE_MB="${3%[mM][bB]*}"  # 3Mb → 3
DATE_SUFFIX=$(date +%d%m%y)
LOG_FILE="/tmp/part2_generation_${DATE_SUFFIX}.log"

if ! validate_params "$FOLDER_LETTERS" "$FILE_PATTERN" "$3"; then
    exit 1
fi

init_log "$LOG_FILE"

# Массив безопасных базовых путей (исключая bin/sbin)
BASE_PATHS=("/home" "/tmp" "/var/tmp" "/opt" "/usr/local" "/srv")

NUM_PAPOK=$(generate_num_folders)  # 1-100
echo "Creating $NUM_PAPOK folders..." | tee -a "$LOG_FILE"

created_count=0
for ((i=1; i<=NUM_PAPOK; i++)); do
    if ! has_enough_space; then
        echo "Stopped: <1GB free on /" | tee -a "$LOG_FILE"
        break
    fi
    
    BASE_PATH="${BASE_PATHS[$((RANDOM % ${#BASE_PATHS[@]}))]}"
    NUM_FILES_IN_FOLDER=$(generate_num_files)  # случайное 1-20
    
    create_single_folder "$BASE_PATH" "$FOLDER_LETTERS" "$DATE_SUFFIX" \
                         "$NUM_FILES_IN_FOLDER" "$FILE_PATTERN" "$FILE_SIZE_MB" "$LOG_FILE"
    
    ((created_count++))
done

END_TIME=$(date +%s)
RUNTIME=$((END_TIME - START_TIME))
echo "=== SUMMARY ===" | tee -a "$LOG_FILE"
echo "Start: $(date -d "@$START_TIME")" | tee -a "$LOG_FILE"
echo "End: $(date -d "@$END_TIME")" | tee -a "$LOG_FILE"
echo "Runtime: ${RUNTIME}s (created $created_count folders)" | tee -a "$LOG_FILE"
