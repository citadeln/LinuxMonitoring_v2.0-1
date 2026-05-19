#!/bin/bash

# HTTP status codes:
# 200 OK - request succeeded.
# 201 Created - resource was created successfully.
# 400 Bad Request - server could not understand the request.
# 401 Unauthorized - authentication is required.
# 403 Forbidden - server refuses to fulfill the request.
# 404 Not Found - requested resource was not found.
# 500 Internal Server Error - generic server error.
# 501 Not Implemented - server does not support the request method.
# 502 Bad Gateway - invalid response from upstream server.
# 503 Service Unavailable - server is temporarily unavailable.

rand_int() {
    local min="$1"
    local max="$2"
    echo $((min + RANDOM % (max - min + 1)))
}

rand_ip() {
    echo "$((1 + RANDOM % 223)).$((RANDOM % 256)).$((RANDOM % 256)).$((1 + RANDOM % 254))"
}

rand_from_array() {
    local -n arr="$1"
    echo "${arr[$((RANDOM % ${#arr[@]}))]}"
}

generate_logs() {
    local base_path="$1"

    local methods=(GET POST PUT PATCH DELETE)
    local statuses=(200 201 400 401 403 404 500 501 502 503)
    local agents=(
        "Mozilla/5.0"
        "Google Chrome/124.0"
        "Opera/110.0"
        "Safari/17.0"
        "Internet Explorer/11.0"
        "Microsoft Edge/125.0"
        "Crawler and bot"
        "Library and net tool"
    )
    local urls=(
        "/"
        "/index.html"
        "/api/v1/users"
        "/api/v1/login"
        "/api/v1/items"
        "/products"
        "/search?q=test"
        "/assets/app.js"
        "/docs"
        "/health"
    )

    for day_offset in 0 1 2 3 4; do
        local log_date file_name entries start_epoch i offset ts dt ip method status url agent bytes
        log_date=$(date -d "-$day_offset day" +%F)
        file_name="$base_path/nginx_access_${log_date}.log"
        entries=$(rand_int 100 1000)

        start_epoch=$(date -d "$log_date 00:00:00" +%s)

        for ((i=0; i<entries; i++)); do
            offset=$((i * 86400 / entries))
            ts=$((start_epoch + offset))
            dt=$(date -d "@$ts" '+%d/%b/%Y:%H:%M:%S %z')
            ip=$(rand_ip)
            method=$(rand_from_array methods)
            status=$(rand_from_array statuses)
            url=$(rand_from_array urls)
            agent=$(rand_from_array agents)
            bytes=$(rand_int 100 50000)

            printf '%s - - [%s] "%s %s HTTP/1.1" %s %s "-" "%s"\n' \
                "$ip" "$dt" "$method" "$url" "$status" "$bytes" "$agent" >> "$file_name"
        done

        echo "Generated: $file_name ($entries lines)"
    done
}
