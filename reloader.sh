#!/bin/bash

# Удаление директории softos
if [ -d "$HOME/softos" ]; then
    echo "Deleting softos directory..."
    rm -rf "$HOME/softos"
    echo "softos directory successfully deleted."
else
    echo "softos directory not found."
fi

# Клонирование репозитория в домашнюю директорию
echo "Cloning repository https://github.com/AstrologSecra/ossoft/ to $HOME..."
git clone https://github.com/AstrologSecra/ossoft/ "$HOME/softos"

if [ $? -eq 0 ]; then
    echo "Repository successfully cloned."
else
    echo "Error cloning repository."
fi
