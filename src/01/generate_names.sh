# #!/bin/bash

# generate_folder_name() {
#     local letters="$1" date_suf="$2"
#     local name=""
#     local counts=()
#     for ((i=0; i<${#letters}; i++)); do counts[i]=1; done  # min 1 each
#     # Генерация: базовая с +a/z... до len>=4
#     for len in {4..10}; do  # примерный диапазон
#         name=$(printf '%*s' "$len" | tr ' ' "${letters:0:1}")  # start with first letter repeats
#         for ((pos=1; posen; pos++)); do
#             rand_letter=${letters:$((RANDOM % ${#letters})):1}
#             name+="$rand_letter"
#         done
#         # Проверка: все буквы использованы хотя бы раз (улучшить с grep -o | sort | uniq)
#         if [[ $(echo "$name" | grep -o . | sort -u | tr -d '\n' | grep -q "^${letters}$" ]]; then
#             echo "${name}_${date_suf}"
#             return
#         fi
#     done
# }

# generate_file_name() {
#     local name_part="$1" ext_part="$2" date_suf="$3"
#     name=$(generate_folder_name "$name_part" "")  # reuse logic
#     ext=$(generate_folder_name "$ext_part" "")
#     echo "${name}_${date_suf}.${ext}"
# }


#!/bin/bash

generate_folder_name() {
    local letters="$1" date_suf="$2"
    local name=""
    # Генерируем имя, пока оно не станет достаточно длинным и не будет содержать все буквы хотя бы раз
    while true; do
        # Генерируем случайную строку из букв, сохраняя порядок набора (просто берем случайные буквы)
        # Длина от 4 до 10 символов для попытки
        local len=$((RANDOM % 7 + 4)) 
        name=$(cat /dev/urandom | tr -dc "$letters" | head -c $len)
        
        # Проверка: все ли буквы из набора letters присутствуют в сгенерированном имени?
        # Вариант с grep (проще):
        if echo "$name" | grep -q "$letters"; then 
            echo "${name}_${date_suf}"
            return
        fi

        # Вариант с сортировкой (как вы хотели изначально):
        # if [[ $(echo "$name" | grep -o . | sort -u | tr -d '\n') == "$letters" ]]; then 
        #     echo "${name}_${date_suf}"
        #     return
        # fi
    done
}

generate_file_name() {
    # Для имени файла и расширения логика проще:
    # 1. Берем случайные буквы из набора для имени.
    # 2. Берем случайные буквы из набора для расширения.
    # 3. Следим за длиной (имя >=4, расширение <=3).
    local name_part="$1" ext_part="$2" date_suf="$3"
    
    # Генерация части имени файла (от 4 до 7 символов)
    local name_len=$((RANDOM % 4 + 4))
    local name_body=$(cat /dev/urandom | tr -dc "$name_part" | head -c $name_len)
    
    # Генерация расширения (от 1 до 3 символов)
    local ext_len=$((RANDOM % 3 + 1))
    local ext_body=$(cat /dev/urandom | tr -dc "$ext_part" | head -c $ext_len)
    
    echo "${name_body}_${date_suf}.${ext_body}"
}