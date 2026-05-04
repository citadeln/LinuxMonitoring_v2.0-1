#!/bin/bash

has_enough_space() {
    df / | tail -1 | awk '$4+0 < 1048576 {exit 1}'
}
