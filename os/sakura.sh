#!/bin/bash

# Установка sakura
echo "Установка sakura..."
sudo apt-get update
sudo apt-get install -y sakura

# Список системных терминалов для удаления
TERMINALS=(
    gnome-terminal
    xfce4-terminal
    konsole
    xterm
    lxterminal
    mate-terminal
    terminator
    guake
    tilix
)

# Удаление системных терминалов
echo "Удаление системных терминалов..."
for TERM in "${TERMINALS[@]}"; do
    if dpkg -s "$TERM" &> /dev/null; then
        echo "Удаление $TERM..."
        sudo apt-get remove -y "$TERM"
    else
        echo "$TERM не установлен, пропускаем."
    fi
done

# Очистка пакетов
echo "Очистка пакетов..."
sudo apt-get autoremove -y
sudo apt-get autoclean

echo "Установка sakura и удаление системных терминалов завершено."
