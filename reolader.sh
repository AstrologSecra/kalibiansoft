#!/bin/bash

# Удаление файла softos
if [ -f "softos" ]; then
    echo "Deleting softos file..."
    rm -rf softos
    echo "softos file successfully deleted."
else
    echo "softos file not found."
fi

# Клонирование репозитория
echo "Cloning repository https://github.com/AstrologSecra/ossoft/..."
git clone https://github.com/AstrologSecra/ossoft/

if [ $? -eq 0 ]; then
    echo "Repository successfully cloned."
else
    echo "Error cloning repository."
fi
