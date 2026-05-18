#!/bin/bash

cleanup_by_time() {
    local base_dir="$1"
    local start_str end_str start_epoch end_epoch

    echo "Time format: YYYY-MM-DD HH:MM"
    read -r -p "Enter start time: " start_str
    read -r -p "Enter end time: " end_str

    if ! validate_time_input "$start_str" || ! validate_time_input "$end_str"; then
        echo "Error: invalid time format."
        return 1
    fi

    start_epoch=$(date -d "$start_str" +%s)
    end_epoch=$(date -d "$end_str" +%s)

    if [ "$start_epoch" -gt "$end_epoch" ]; then
        echo "Error: start time must be earlier than end time."
        return 1
    fi

    # Находим все папки, созданные в заданном промежутке, и удаляем их рекурсивно
    while IFS= read -r -d '' folder; do
        local birth_epoch=$(stat -c %Y -- "$folder" 2>/dev/null)
        if [ -n "$birth_epoch" ] && [ "$birth_epoch" -ge "$start_epoch" ] && [ "$birth_epoch" -le "$end_epoch" ]; then
            rm -rf -- "$folder"
        fi
    done < <(find "$base_dir" -type d -name "*_*" -print0)

    # Находим все файлы, созданные в заданном промежутке, и удаляем их
    while IFS= read -r -d '' file; do
        local birth_epoch=$(stat -c %Y -- "$file" 2>/dev/null)
        if [ -n "$birth_epoch" ] && [ "$birth_epoch" -ge "$start_epoch" ] && [ "$birth_epoch" -le "$end_epoch" ]; then
            rm -f -- "$file"
        fi
    done < <(find "$base_dir" -type f ! -name "*_*" -print0)
}



# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ ./02/main.sh az az.az 3Mb
# Creating up to 87 nested folders in: /home/mon/projects/LinuxMonitoring_v2.0-1/src
# === SUMMARY ===
# Start: Mon 18 May 2026 04:00:19 PM UTC
# End: Mon 18 May 2026 04:00:30 PM UTC
# Runtime: 11s (created 87 nested folders)
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ ./03/main.sh 
# === Part 3 cleanup menu ===
# Choose cleanup method:
# 1) By log file
# 2) By creation time
# 3) By name mask


# В моде по времени удаляется много лишнего:
# Enter your choice (1-3): 2
# Time format: YYYY-MM-DD HH:MM
# Enter start time: 2026-05-18 00:00
# Enter end time: 2026-05-19 00:00
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ ls
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ ls
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ ls -la
# total 0
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ git pull
# fatal: Unable to read current working directory: No such file or directory
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ cd ..
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ git pull
# Already up to date.
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ ls
# README.md  README_RUS.md  materials
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ cd ..
# mon@lmon:~/projects$ ls
# LinuxMonitoring_v2.0-1
# mon@lmon:~/projects$ cd LinuxMonitoring_v2.0-1/
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ ls
# README.md  README_RUS.md  materials
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ git pull
# Already up to date.
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ git stash
# Saved working directory and index state WIP on main: d949f2e fix: validation and modes
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ ls
# README.md  README_RUS.md  materials  src
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1$ cd src
# mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ 

# должны были удалиться только эти файлы: созданные в момент (mon@lmon:~/projects/LinuxMonitoring_v2.0-1/src$ ./02/main.sh az az.az 3Mb
# Creating up to 87 nested folders in: /home/mon/projects/LinuxMonitoring_v2.0-1/src
# === SUMMARY ===
# Start: Mon 18 May 2026 04:00:19 PM UTC
# End: Mon 18 May 2026 04:00:30 PM UTC
# Runtime: 11s (created 87 nested folders))
# но точно не пропасть вся папка src! 

# Кроме того необходимо удалять ещё и лог во всех трех модах, то есть файл, который создан по шаблону: generation_part2_160526.log
# generation_part2 нижнее подчеркивание и та же дата что и у папки которую удаляли затем точка и log.
# В Моде по логу - будет сразу название файла который надо в конце удалить.
