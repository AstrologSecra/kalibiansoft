#!/bin/bash

# Функция для установки тем и иконок для GNOME
setup_gnome() {
    echo "Настройка GNOME..."

    # Установка темы Nordic
    sudo apt-get update
    sudo apt-get install -y gnome-tweaks gnome-shell-extensions
    git clone https://github.com/EliverLara/Nordic.git /usr/share/themes/Nordic
    gsettings set org.gnome.desktop.interface gtk-theme 'Nordic'

    # Установка иконок Papirus
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt-get update
    sudo apt-get install -y papirus-icon-theme
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

    # Установка шрифтов
    gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Sans 11'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'

    # Установка расширений GNOME
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    gnome-extensions enable dash-to-dock@micxgx.gmail.com

    echo "GNOME настроен. Перезапуск сессии..."
    gnome-session-quit --logout --no-prompt
}

# Функция для установки тем и иконок для KDE Plasma
setup_kde() {
    echo "Настройка KDE Plasma..."

    # Установка темы Future
    sudo apt-get update
    sudo apt-get install -y kde-config-gtk-style kde-config-gtk-style-preview
    git clone https://github.com/zayronxio/Zafiro-icons.git /usr/share/icons/Zafiro-icons
    kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "BreezeDark"
    kwriteconfig5 --file ~/.config/kdeglobals --group General --key Name "Future"

    # Установка иконок Papirus
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt-get update
    sudo apt-get install -y papirus-icon-theme
    kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "Papirus"

    # Установка шрифтов
    kwriteconfig5 --file ~/.config/kdeglobals --group General --key font "Ubuntu,11,-1,5,50,0,0,0,0,0"
    kwriteconfig5 --file ~/.config/kdeglobals --group General --key fixed "Ubuntu Mono,13,-1,5,50,0,0,0,0,0"

    echo "KDE Plasma настроен. Перезапуск сессии..."
    qdbus org.kde.ksmserver /KSMServer logout 0 0 0
}

# Функция для установки тем и иконок для XFCE
setup_xfce() {
    echo "Настройка XFCE..."

    # Установка темы Sweet
    sudo apt-get update
    sudo apt-get install -y xfce4-settings
    git clone https://github.com/EliverLara/Sweet.git /usr/share/themes/Sweet
    xfconf-query -c xsettings -p /Net/ThemeName -s "Sweet"

    # Установка иконок Papirus
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt-get update
    sudo apt-get install -y papirus-icon-theme
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"

    # Установка шрифтов
    xfconf-query -c xsettings -p /Gtk/FontName -s "Ubuntu 11"
    xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Ubuntu Mono 13"

    echo "XFCE настроен. Перезапуск сессии..."
    xfce4-session-logout --logout
}

# Функция для установки тем и иконок для LXDE
setup_lxde() {
    echo "Настройка LXDE..."

    # Установка темы Adapta Colorpack
    sudo apt-get update
    sudo apt-get install -y lxde-common
    git clone https://github.com/adapta-project/adapta-gtk-theme.git /usr/share/themes/Adapta
    lxpanelctl restart

    # Установка иконок Papirus
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt-get update
    sudo apt-get install -y papirus-icon-theme
    pcmanfm --set-wallpaper /usr/share/icons/Papirus

    # Установка шрифтов
    lxpanelctl restart

    echo "LXDE настроен. Перезапуск сессии..."
    lxsession-logout
}

# Определение текущей среды рабочего стола
if [ "$XDG_CURRENT_DESKTOP" == "GNOME" ]; then
    setup_gnome
elif [ "$XDG_CURRENT_DESKTOP" == "KDE" ]; then
    setup_kde
elif [ "$XDG_CURRENT_DESKTOP" == "XFCE" ]; then
    setup_xfce
elif [ "$XDG_CURRENT_DESKTOP" == "LXDE" ]; then
    setup_lxde
else
    echo "Неизвестная среда рабочего стола. Скрипт не может быть выполнен."
fi
