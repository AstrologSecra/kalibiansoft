#!/bin/bash

# Функция для создания резервной копии
create_backup() {
    local source_dir=$1
    local backup_name=$2
    local backup_dir="$HOME/backups"

    # Создание директории для резервных копий, если она не существует
    mkdir -p "$backup_dir"

    # Создание архива
    tar -czvf "$backup_dir/$backup_name.tar.gz" -C "$source_dir" .

    echo "Резервная копия создана: $backup_dir/$backup_name.tar.gz"
}

# Основная логика
echo "Введите директорию, содержимое которой нужно архивировать:"
read source_dir

echo "Введите имя резервной копии (без расширения):"
read backup_name

# Проверка, существует ли исходная директория
if [ ! -d "$source_dir" ]; then
    echo "Директория $source_dir не существует. Завершение работы."
    exit 1
fi

# Создание резервной копии
create_backup "$source_dir" "$backup_name"
