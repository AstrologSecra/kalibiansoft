#!/bin/bash

# Установка переменных
PACKAGE_NAME="kresmon"
VERSION="1.0.0"
ARCH="amd64"
MAINTAINER="Your Name <your.email@example.com>"
DESCRIPTION="A simple Go application to monitor CPU usage and top processes."
ICON_PATH="kresmon.ico"

# Создание структуры директорий
mkdir -p ./deb-package/DEBIAN
mkdir -p ./deb-package/usr/local/bin
mkdir -p ./deb-package/usr/share/icons/hicolor/48x48/apps

# Копирование бинарного файла в пакет
go build -o ./deb-package/usr/local/bin/kresmon main.go

# Копирование иконки в пакет
cp $ICON_PATH ./deb-package/usr/share/icons/hicolor/48x48/apps/kresmon.ico

# Создание файла управления пакета
cat <<EOF > ./deb-package/DEBIAN/control
Package: $PACKAGE_NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
Icon: /usr/share/icons/hicolor/48x48/apps/kresmon.ico
EOF

# Сборка пакета
dpkg-deb --build ./deb-package

# Переименование пакета
mv deb-package.deb ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb

# Очистка временных файлов
rm -rf ./deb-package

echo "Package ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb has been created."
