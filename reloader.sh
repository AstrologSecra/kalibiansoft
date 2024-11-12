#!/bin/bash

# Удаление файла softos
if [ -f "$HOME/softos" ]; then
    echo "Deleting softos file..."
    rm -rf "$HOME/softos"
    echo "softos file successfully deleted."
else
    echo "softos file not found."
fi

# Клонирование репозитория в домашнюю директорию
echo "Cloning repository https://github.com/AstrologSecra/ossoft/ to $HOME..."
git clone https://github.com/AstrologSecra/ossoft/ "$HOME/softos"

if [ $? -eq 0 ]; then
    echo "Repository successfully cloned."
else
    echo "Error cloning repository."
fi
