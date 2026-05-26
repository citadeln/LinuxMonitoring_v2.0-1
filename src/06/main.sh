#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_PATH="$(pwd)"

if [[ "$BASE_PATH" =~ (bin|sbin) ]]; then
    echo "Error: current path contains bin or sbin: $BASE_PATH"
    exit 1
fi

# process substitution: результат команды внутри <(...) подставляется как “виртуальный файл”, из которого можно читать вывод
mapfile -t LOG_FILES < <(find "$BASE_PATH" -maxdepth 1 -type f -name 'nginx_access_*.log' | sort)

if [ "${#LOG_FILES[@]}" -eq 0 ]; then
    echo "Error: no nginx_access_*.log files found in $BASE_PATH"
    exit 1
fi

OUTPUT_DIR="$BASE_PATH/goaccess_report"
mkdir -p "$OUTPUT_DIR"

REPORT_HTML="$OUTPUT_DIR/report.html"
CONFIG_FILE="$OUTPUT_DIR/goaccess.conf"

cat > "$CONFIG_FILE" <<EOF
date-format %d/%b/%Y
time-format %H:%M:%S
log-format COMBINED
html-report-title GoAccess report
EOF

goaccess "${LOG_FILES[@]}" \
    --config-file="$CONFIG_FILE" \
    --output="$REPORT_HTML"

echo "Report generated: $REPORT_HTML"
echo "Open it in browser:"
echo "file://$REPORT_HTML"

xdg-open file://$REPORT_HTML


# Для combined-формата можно сразу указать формат логов и файл (смотреть в терминале):
# goaccess nginx_access_*.log --log-format=COMBINED

# Веб-страница с отчётом:
# goaccess nginx_access_*.log --log-format=COMBINED -o report.html

# Если нужен интерактивный веб-интерфейс в реальном времени, запускай так:
# goaccess nginx_access_*.log --log-format=COMBINED --real-time-html -o report.html

# --daemonize запускает GoAccess как демон
# goaccess $PWD/nginx_access_*.log --log-format=COMBINED --real-time-html -o $PWD/report.html --daemonize
# pkill goaccess
