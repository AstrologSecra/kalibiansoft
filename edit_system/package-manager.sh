#!/bin/bash

# Функция для получения списка служб
get_services() {
    systemctl list-units --type=service --state=active --no-pager | awk '{print $1}' | grep -v "UNIT"
}

# Функция для получения списка файлов в директории
get_files() {
    local dir="$1"
    find "$dir" -type f
}

# Функция для управления службами
manage_services() {
    services=("$@")
    if [ ${#services[@]} -gt 0 ]; then
        for service in "${services[@]}"; do
            sudo systemctl stop "$service"
            sudo systemctl disable "$service"
        done
    fi
}

# Функция для удаления файлов
remove_files() {
    files=("$@")
    if [ ${#files[@]} -gt 0 ]; then
        for file in "${files[@]}"; do
            sudo rm -f "$file"
        done
    fi
}

# Получаем список служб
services=($(get_services))

# Получаем список файлов в /etc
files=($(get_files "/etc"))

# Создаем список служб и файлов для выбора
item_list=()
for service in "${services[@]}"; do
    item_list+=("$service" "Служба" "off")
done
for file in "${files[@]}"; do
    item_list+=("$file" "Файл" "off")
done

# Показываем диалог выбора элементов
selected_items=$(zenity --list --checklist \
    --title="Управление компонентами" \
    --text="Выберите компоненты для удаления или остановки:" \
    --column="Удалить" --column="Компонент" --column="Тип" \
    "${item_list[@]}" \
    --separator=" " \
    --width=600 --height=400)

# Проверяем, были ли выбраны элементы
if [ -z "$selected_items" ]; then
    zenity --info --title="Выход" --text="Компоненты не выбраны. Выход."
    exit 0
fi

# Преобразуем выбранные элементы в массив
IFS=' ' read -r -a selected_items_array <<< "$selected_items"

# Спрашиваем, что делать с выбранными элементами
action=$(zenity --list --radiolist \
    --title="Действие" \
    --text="Что вы хотите сделать с выбранными компонентами?" \
    --column="Выбрать" --column="Действие" \
    TRUE "Остановить службы и удалить файлы" \
    --width=300 --height=200)

# Выполняем действие
if [ "$action" == "Остановить службы и удалить файлы" ]; then
    manage_services "${selected_items_array[@]}"
    remove_files "${selected_items_array[@]}"
else
    zenity --info --title="Выход" --text="Действие не выбрано. Выход."
    exit 0
fi

zenity --info --title="Готово" --text="Операция завершена."