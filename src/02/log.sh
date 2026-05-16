#!/bin/bash

init_log() {
    echo "Part 2 log started: $(date)" > "$1"
}

log_entry() {
    echo "$*" >> "$1"
}