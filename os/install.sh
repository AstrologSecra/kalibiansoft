#!/bin/bash

# Список файлов с расширением .sh, которые нужно выполнить
FILES_TO_EXECUTE=(
"kdesktop.sh"
"wallaper_change.sh"
"sakura.sh"
)

# Перебор всех файлов в списке
for FILE in "${FILES_TO_EXECUTE[@]}"; do
    # Проверка наличия файла
    if [ ! -f "$FILE" ]; then
        echo "Файл $FILE не найден."
        continue
    fi

    # Даем права на выполнение
    chmod +x "$FILE"
    if [ $? -ne 0 ]; then
        echo "Не удалось дать права на выполнение для файла $FILE."
        continue
    fi

    # Выполняем файл
    echo "Выполняем файл $FILE..."
    ./"$FILE"
    if [ $? -ne 0 ]; then
        echo "Ошибка при выполнении файла $FILE."
    else
        echo "Файл $FILE успешно выполнен."
    fi
done

echo "Все файлы успешно обработаны."
