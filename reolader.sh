#!/bin/bash

# Удаление файла softos
if [ -f "softos" ]; then
    echo "Удаление файла softos..."
    rm -rf softos
    echo "Файл softos успешно удален."
else
    echo "Файл softos не найден."
fi

# Клонирование репозитория
echo "Клонирование репозитория https://github.com/AstrologSecra/ossoft/..."
git clone https://github.com/AstrologSecra/ossoft/

if [ $? -eq 0 ]; then
    echo "Репозиторий успешно склонирован."
else
    echo "Ошибка при клонировании репозитория."
fi
