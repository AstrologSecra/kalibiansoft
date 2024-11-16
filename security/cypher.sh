#!/bin/bash

# Функция для проверки пароля
check_password() {
    read -sp "Введите пароль (оставьте пустым, чтобы не использовать): " password
    echo
    if [ -z "$password" ]; then
        echo "Пароль не будет использоваться."
    else
        echo "Пароль будет использоваться."
        SCRIPT_PASSWORD="$password"
    fi
}

# Функция для шифрования файла
encrypt_file() {
    local file=$1
    local output_file="${file}.gpg"

    gpg --symmetric --output "$output_file" "$file"
    echo "Файл зашифрован: $output_file"
}

# Функция для дешифрования файла
decrypt_file() {
    local file=$1
    local output_file="${file%.gpg}"

    gpg --decrypt --output "$output_file" "$file"
    echo "Файл расшифрован: $output_file"
}

# Функция для шифрования директории
encrypt_directory() {
    local dir=$1
    local output_file="${dir}.tar.gz.gpg"

    tar -czf - "$dir" | gpg --symmetric --output "$output_file"
    echo "Директория зашифрована: $output_file"
}

# Функция для дешифрования директории
decrypt_directory() {
    local file=$1
    local output_dir="${file%.tar.gz.gpg}"

    gpg --decrypt --output - "$file" | tar -xzf - -C "$(dirname "$output_dir")"
    echo "Директория расшифрована: $output_dir"
}

# Функция для установки зависимостей с использованием apt
install_dependencies_apt() {
    echo "Установка зависимостей (gnupg)..."
    sudo apt-get update || { echo "Ошибка обновления списка пакетов"; exit 1; }
    sudo apt-get install -y gnupg || { echo "Ошибка установки зависимостей"; exit 1; }
}

# Функция для установки зависимостей с использованием pacman
install_dependencies_pacman() {
    echo "Установка зависимостей (gnupg)..."
    sudo pacman -Syu --noconfirm || { echo "Ошибка обновления списка пакетов"; exit 1; }
    sudo pacman -S --noconfirm gnupg || { echo "Ошибка установки зависимостей"; exit 1; }
}

# Функция для выбора пакетного менеджера
choose_package_manager() {
    local choice=$(zenity --list --title="Выбор пакетного менеджера" --text="Выберите пакетный менеджер:" --column="Пакетный менеджер" "apt" "pacman")

    case $choice in
        "apt")
            install_dependencies_apt
            ;;
        "pacman")
            install_dependencies_pacman
            ;;
        *)
            zenity --error --title="Ошибка" --text="Неверный выбор. Выход."
            exit 1
            ;;
    esac
}

# Установка зависимостей
echo "Установка зависимостей..."
choose_package_manager

# Проверка пароля
check_password

# Основной цикл программы
while true; do
    echo "Выберите действие:"
    echo "1. Шифровать файл"
    echo "2. Дешифровать файл"
    echo "3. Шифровать директорию"
    echo "4. Дешифровать директорию"
    echo "5. Выход"
    read -p "Введите номер действия: " choice

    case $choice in
        1)
            read -p "Введите путь к файлу для шифрования: " file
            if [ -n "$file" ]; then
                encrypt_file "$file"
            fi
            ;;
        2)
            read -p "Введите путь к файлу для дешифрования: " file
            if [ -n "$file" ]; then
                decrypt_file "$file"
            fi
            ;;
        3)
            read -p "Введите путь к директории для шифрования: " dir
            if [ -n "$dir" ]; then
                encrypt_directory "$dir"
            fi
            ;;
        4)
            read -p "Введите путь к файлу для дешифрования директории: " file
            if [ -n "$file" ]; then
                decrypt_directory "$file"
            fi
            ;;
        5)
            break
            ;;
        *)
            echo "Неверный выбор"
            ;;
    esac
done
