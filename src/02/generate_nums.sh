#!/bin/bash

generate_num_folders() {
    echo $((1 + RANDOM % 100))  # 1-100 папок
}

generate_num_files() {
    echo $((1 + RANDOM % 20))   # 1-20 файлов в папке
}
