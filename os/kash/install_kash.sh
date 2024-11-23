#!/bin/bash

# Сборка бинарного файла
go build -o kash kash.go

# Создание структуры директорий для .deb пакета
mkdir -p kash_1.0.0/usr/local/bin
cp kash kash_1.0.0/usr/local/bin/
mkdir -p kash_1.0.0/DEBIAN

# Создание файла управления control
cat <<EOF > kash_1.0.0/DEBIAN/control
Package: kash
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Your Name <your.email@example.com>
Description: Simple Command Line Interpreter
 This is a simple command line interpreter written in Go.
EOF

# Создание скрипта postinst
cat <<EOF > kash_1.0.0/DEBIAN/postinst
#!/bin/bash
chmod +x /usr/local/bin/kash
EOF

chmod 755 kash_1.0.0/DEBIAN/postinst

# Создание .deb пакета
dpkg-deb --build kash_1.0.0

# Установка .deb пакета с правами суперпользователя
sudo dpkg -i kash_1.0.0.deb

# Создание директории для иконки
sudo mkdir -p /usr/share/icons/hicolor/48x48/apps/

# Копирование иконки в системную директорию
sudo cp ico.ico /usr/share/icons/hicolor/48x48/apps/kash.ico

# Обновление кэша иконок
sudo update-icon-caches /usr/share/icons/hicolor/

# Создание .desktop файла
cat <<EOF > kash.desktop
[Desktop Entry]
Version=1.0
Name=Kash
Comment=Simple Command Line Interpreter
Exec=/usr/local/bin/kash
Icon=/usr/share/icons/hicolor/48x48/apps/kash.ico
Terminal=true
Type=Application
Categories=Utility;
EOF

# Установка .desktop файла
sudo cp kash.desktop /usr/share/applications/

# Очистка временных файлов
rm -rf kash_1.0.0
rm kash
rm kash.desktop

echo "Package kash_1.0.0.deb created and installed successfully."
