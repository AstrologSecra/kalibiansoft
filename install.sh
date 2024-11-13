#!/bin/bash

# Переменные
REPO_URL="https://github.com/AstrologSecra/ossoft.git"
REPO_DIR="ossoft"

# Клонирование репозитория
echo "Клонирование репозитория..."
git clone "$REPO_URL" "$REPO_DIR" || { echo "Ошибка при клонировании репозитория"; exit 1; }

# Переход в директорию репозитория
cd "$REPO_DIR" || { echo "Ошибка при переходе в директорию репозитория"; exit 1; }

# Установка зависимостей
echo "Установка зависимостей..."

# Проверка наличия файла apt-requirements.txt
if [ -f "apt-requirements.txt" ]; then
    echo "Обнаружен apt-requirements.txt, установка системных зависимостей..."
    sudo apt-get update || { echo "Ошибка при обновлении списка пакетов"; exit 1; }
    sudo apt-get install -y $(cat apt-requirements.txt) || { echo "Ошибка при установке системных зависимостей"; exit 1; }
fi

# Проверка наличия файла requirements.txt (для Python)
if [ -f "requirements.txt" ]; then
    echo "Обнаружен requirements.txt, установка Python-зависимостей..."
    pip install -r requirements.txt || { echo "Ошибка при установке Python-зависимостей"; exit 1; }
fi

# Проверка наличия файла package.json (для Node.js)
if [ -f "package.json" ]; then
    echo "Обнаружен package.json, установка Node.js-зависимостей..."
    npm install || { echo "Ошибка при установке Node.js-зависимостей"; exit 1; }
fi

# Проверка наличия файла Gemfile (для Ruby)
if [ -f "Gemfile" ]; then
    echo "Обнаружен Gemfile, установка Ruby-зависимостей..."
    bundle install || { echo "Ошибка при установке Ruby-зависимостей"; exit 1; }
fi

# Проверка наличия файла composer.json (для PHP)
if [ -f "composer.json" ]; then
    echo "Обнаружен composer.json, установка PHP-зависимостей..."
    composer install || { echo "Ошибка при установке PHP-зависимостей"; exit 1; }
fi

# Проверка наличия файла Cargo.toml (для Rust)
if [ -f "Cargo.toml" ]; then
    echo "Обнаружен Cargo.toml, установка Rust-зависимостей..."
    cargo build || { echo "Ошибка при установке Rust-зависимостей"; exit 1; }
fi

# Проверка наличия файла go.mod (для Go)
if [ -f "go.mod" ]; then
    echo "Обнаружен go.mod, установка Go-зависимостей..."
    go mod download || { echo "Ошибка при установке Go-зависимостей"; exit 1; }
fi

echo "Установка зависимостей завершена успешно."
