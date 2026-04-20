#!/bin/bash

get_free_gb() {
    df -h / | tail -1 | awk '{print $4}' | sed 's/G$//; s/M$/0.001/; s/T$/1000/; s/[^0-9.]//g'
}

has_enough_space() {
    local free_gb=$(get_free_gb)
    awk "BEGIN {exit !($free_gb >= 1)}"  # true if >=1GB
}
