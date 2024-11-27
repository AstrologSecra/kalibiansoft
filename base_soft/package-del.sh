#!/bin/bash

# Функция для получения списка установленных пакетов с использованием apt
get_installed_packages_apt() {
    dpkg-query -W -f='${Package}\n'
}

# Функция для удаления пакетов с использованием apt
remove_packages_apt() {
    packages=("$@")
    if [ ${#packages[@]} -gt 0 ]; then
        sudo apt-get remove --purge "${packages[@]}"
    fi
}

# Функция для получения списка установленных пакетов с использованием pacman
get_installed_packages_pacman() {
    pacman -Qq
}

# Функция для удаления пакетов с использованием pacman
remove_packages_pacman() {
    packages=("$@")
    if [ ${#packages[@]} -gt 0 ]; then
        sudo pacman -Rns "${packages[@]}"
    fi
}

# Функция для выбора пакетного менеджера
choose_package_manager() {
    local choice=$(zenity --list --title="Выбор пакетного менеджера" --text="Выберите пакетный менеджер:" --column="Пакетный менеджер" "apt" "pacman")

    case $choice in
        "apt")
            get_installed_packages=get_installed_packages_apt
            remove_packages=remove_packages_apt
            ;;
        "pacman")
            get_installed_packages=get_installed_packages_pacman
            remove_packages=remove_packages_pacman
            ;;
        *)
            zenity --error --title="Ошибка" --text="Неверный выбор. Выход."
            exit 1
            ;;
    esac
}

# Выбираем пакетный менеджер
choose_package_manager

# Получаем список установленных пакетов
installed_packages=($($get_installed_packages))

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
$remove_packages "${selected_packages_array[@]}"

zenity --info --title="Готово" --text="Операция завершена."
