#!/bin/bash

init_log() {
    echo "Log started: $(date)" > "$1"
}

log_entry() {
    echo "$1" >> "$2"
}
