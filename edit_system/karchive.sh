#!/bin/bash

# Функция для архивации
function archive {
    FILES=$(zenity --file-selection --multiple --separator=" " --title="Выберите файлы для архивации")
    if [ -z "$FILES" ]; then
        zenity --error --text="Файлы не выбраны"
        exit 1
    fi

    ARCHIVE_NAME=$(zenity --entry --title="Имя архива" --text="Введите имя архива:")
    if [ -z "$ARCHIVE_NAME" ]; then
        zenity --error --text="Имя архива не задано"
        exit 1
    fi

    FORMAT=$(zenity --list --radiolist --title="Формат архива" --text="Выберите формат архива" --column="Выбор" --column="Формат" TRUE "7z" FALSE "zip")

    case "$FORMAT" in
        "7z")
            if 7z a "$ARCHIVE_NAME.7z" $FILES; then
                zenity --info --text="Архив успешно создан: $ARCHIVE_NAME.7z"
            else
                zenity --error --text="Ошибка при создании архива"
            fi
            ;;
        "zip")
            if zip "$ARCHIVE_NAME.zip" $FILES; then
                zenity --info --text="Архив успешно создан: $ARCHIVE_NAME.zip"
            else
                zenity --error --text="Ошибка при создании архива"
            fi
            ;;
        *)
            zenity --error --text="Формат архива не выбран"
            exit 1
            ;;
    esac
}

# Функция для распаковки
function extract {
    ARCHIVE=$(zenity --file-selection --title="Выберите архив для распаковки")
    if [ -z "$ARCHIVE" ]; then
        zenity --error --text="Архив не выбран"
        exit 1
    fi

    # Директория для распаковки
    DEST_DIR="karchive"

    # Проверка существования директории
    if [ ! -d "$DEST_DIR" ]; then
        mkdir "$DEST_DIR"
    fi

    case "$ARCHIVE" in
        *.7z)
            if 7z x "$ARCHIVE" -o"$DEST_DIR"; then
                zenity --info --text="Архив успешно распакован в $DEST_DIR"
            else
                zenity --error --text="Ошибка при распаковке архива"
            fi
            ;;
        *.zip)
            if unzip "$ARCHIVE" -d "$DEST_DIR"; then
                zenity --info --text="Архив успешно распакован в $DEST_DIR"
            else
                zenity --error --text="Ошибка при распаковке архива"
            fi
            ;;
        *)
            zenity --error --text="Неподдерживаемый формат архива"
            exit 1
            ;;
    esac
}

# Главное меню
CHOICE=$(zenity --list --radiolist --title="Архиватор" --text="Выберите действие" --column="Выбор" --column="Действие" TRUE "Архивировать" FALSE "Распаковать")

case "$CHOICE" in
    "Архивировать")
        archive
        ;;
    "Распаковать")
        extract
        ;;
    *)
        zenity --error --text="Действие не выбрано"
        exit 1
        ;;
esac
