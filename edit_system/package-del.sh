#!/bin/bash

# Функция для получения списка установленных пакетов
get_installed_packages() {
    dpkg-query -W -f='${Package}\n'
}

# Функция для удаления пакетов
remove_packages() {
    packages=("$@")
    if [ ${#packages[@]} -gt 0 ]; then
        sudo apt-get remove --purge "${packages[@]}"
    fi
}

# Получаем список установленных пакетов
installed_packages=($(get_installed_packages))

# Создаем список пакетов для выбора
package_list=()
for package in "${installed_packages[@]}"; do
    package_list+=("$package" "$package")
done

# Показываем диалог выбора пакетов
selected_packages=$(zenity --list --checklist \
    --title="Удаление пакетов" \
    --text="Выберите пакеты для удаления:" \
    --column="Удалить" --column="Пакет" \
    "${package_list[@]}" \
    --separator=" " \
    --width=600 --height=400)

# Проверяем, были ли выбраны пакеты
if [ -z "$selected_packages" ]; then
    zenity --info --title="Выход" --text="Пакеты не выбраны. Выход."
    exit 0
fi

# Преобразуем выбранные пакеты в массив
IFS=' ' read -r -a selected_packages_array <<< "$selected_packages"

# Удаляем выбранные пакеты
remove_packages "${selected_packages_array[@]}"

zenity --info --title="Готово" --text="Операция завершена."
