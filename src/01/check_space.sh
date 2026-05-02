#!/bin/bash

# get_free_kb() {
#     df / | tail -1 | awk '{print $4}' | sed 's/,//g'
# }

# has_enough_space() {
#     local free_kb=$(get_free_kb)
#     # 1 Гигабайт = 1024 * 1024 = 1048576 Килобайт
#     awk "BEGIN {exit ($free_kb < 1048576)}"
# }

has_enough_space() {
    df / | tail -1 | awk '$4+0 < 1048576 {exit 1}'
}