import os
import random
import subprocess
import time

def find_wallpaper_dir():
    # Получаем текущую директорию
    current_dir = os.getcwd()
    # Создаем путь к папке wallpapers
    wallpaper_dir = os.path.join(current_dir, "wallpapers")
    # Проверяем, существует ли папка wallpapers
    if not os.path.exists(wallpaper_dir):
        raise FileNotFoundError("Wallpaper directory not found")
    return wallpaper_dir

def get_desktop_environment():
    # Определяем текущую среду рабочего стола
    desktop_env = os.getenv("XDG_CURRENT_DESKTOP", "GNOME")
    return desktop_env

def set_gnome_wallpaper(wallpaper):
    # Устанавливаем обои для GNOME
    subprocess.run(["gsettings", "set", "org.gnome.desktop.background", "picture-uri", f"file://{wallpaper}"])

def set_kde_wallpaper(wallpaper):
    # Устанавливаем обои для KDE
    script = f"""
    var allDesktops = desktops();
    for (i=0;i<allDesktops.length;i++) {{
        d = allDesktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
        d.writeConfig("Image", "file://{wallpaper}")
    }}
    """
    subprocess.run(["qdbus", "org.kde.plasmashell", "/PlasmaShell", "org.kde.PlasmaShell.evaluateScript", script])

def set_lxde_wallpaper(wallpaper):
    # Устанавливаем обои для LXDE
    subprocess.run(["pcmanfm", "--set-wallpaper", wallpaper, "--wallpaper-mode=fit"])

def set_xfce_wallpaper(wallpaper):
    # Устанавливаем обои для XFCE
    subprocess.run(["xfconf-query", "-c", "xfce4-desktop", "-p", "/backdrop/screen0/monitor0/workspace0/last-image", "-s", wallpaper])

def main():
    # Инициализируем генератор случайных чисел
    random.seed(time.time())

    # Ищем папку с обоями
    try:
        wallpaper_dir = find_wallpaper_dir()
    except FileNotFoundError as e:
        print(f"Error finding wallpaper directory: {e}")
        return

    # Получаем список всех обоев в папке
    wallpapers = [os.path.join(wallpaper_dir, f) for f in os.listdir(wallpaper_dir) if f.endswith(".jpg")]

    if not wallpapers:
        print("No wallpapers found in the directory.")
        return

    # Выбираем случайное обои
    random_wallpaper = random.choice(wallpapers)

    # Определяем среду рабочего стола и устанавливаем обои
    desktop_env = get_desktop_environment()
    if desktop_env in ["GNOME", "UNITY", "MATE", "CINNAMON"]:
        set_gnome_wallpaper(random_wallpaper)
    elif desktop_env == "KDE":
        set_kde_wallpaper(random_wallpaper)
    elif desktop_env == "LXDE":
        set_lxde_wallpaper(random_wallpaper)
    elif desktop_env == "XFCE":
        set_xfce_wallpaper(random_wallpaper)
    else:
        print("Unsupported desktop environment.")

if __name__ == "__main__":
    main()
