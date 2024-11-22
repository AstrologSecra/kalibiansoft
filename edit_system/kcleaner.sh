#!/bin/bash

# Функция для удаления файлов
delete_files() {
    local pattern=$1
    local files=($(sudo find / -type f -name "$pattern" 2>/dev/null))

    if [ ${#files[@]} -eq 0 ]; then
        echo "Файлы, соответствующие шаблону '$pattern', не найдены."
        return
    fi

    echo "Найдены следующие файлы для удаления:"
    for file in "${files[@]}"; do
        echo "$file"
    done

    read -p "Вы уверены, что хотите удалить все эти файлы? (Да/Нет): " confirm
    if [[ "$confirm" =~ ^[Yy][Ee][Ss]$|^[Yy]$ ]]; then
        for file in "${files[@]}"; do
            sudo rm -f "$file"
            echo "Удален: $file"
        done
    else
        echo "Отмена удаления."
    fi
}

# Запрашиваем шаблон для поиска файлов
read -p "Введите шаблон для поиска файлов (например, '*.log'): " pattern

# Удаляем файлы
delete_files "$pattern"

echo "Готово."
