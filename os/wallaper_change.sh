#!/bin/bash

# Путь к файлу с обоями относительно директории kalibiansoft
WALLPAPER_PATH="$PWD/wall.jpg"

# Проверка наличия файла с обоями
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Файл обоев $WALLPAPER_PATH не найден."
    exit 1
fi

# Определение текущей графической оболочки
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "Unity" ]; then
    # Для GNOME и Unity
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH"
elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    # Для KDE
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
        var allDesktops = desktops();
        for (i=0;i<allDesktops.length;i++) {
            d = allDesktops[i];
            d.wallpaperPlugin = 'org.kde.image';
            d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
            d.writeConfig('Image', 'file://$WALLPAPER_PATH');
        }
    "
elif [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
    # Для XFCE
    for MONITOR in $(xfconf-query -c xfce4-desktop -l | grep -E -e "monitor.*workspace.*last-image$"); do
        xfconf-query -c xfce4-desktop -p "$MONITOR" -s "$WALLPAPER_PATH"
    done
elif [ "$XDG_CURRENT_DESKTOP" = "LXDE" ]; then
    # Для LXDE
    pcmanfm --set-wallpaper="$WALLPAPER_PATH" --wallpaper-mode=fit
else
    echo "Не удалось определить графическую оболочку."
    exit 1
fi

echo "Обои успешно изменены на $WALLPAPER_PATH."
