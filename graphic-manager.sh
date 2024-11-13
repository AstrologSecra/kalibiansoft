#!/bin/bash

# Function to remove existing graphics
remove_existing_graphics() {
    # List of graphics packages that may be installed
    local graphics_packages=("xorg" "xserver-xorg" "x11-common" "x11-utils" "x11-xserver-utils" "x11-xkb-utils" "x11-apps" "x11-session-utils" "x11-xfs-utils" "x11-xinit-session" "x11-xdm-session" "x11-xdm-theme" "x11-xdm-theme-default" "x11-xdm-theme-gnome" "x11-xdm-theme-kde" "x11-xdm-theme-xfce" "x11-xdm-theme-lxde")

    # Remove graphics packages
    for package in "${graphics_packages[@]}"; do
        if dpkg -l | grep -q "^ii  $package"; then
            sudo apt-get remove --purge -y "$package"
        fi
    done

    # Autoremove unnecessary packages
    sudo apt-get autoremove -y
}

# Function to install new graphics
install_graphics() {
    local graphics_path=$1
    local target_path=$2

    # Copy new graphics
    sudo cp -r "$graphics_path"/* "$target_path/"

    # Reboot the computer
    zenity --question --title="Reboot" --text="Graphics successfully installed. Reboot the computer now?"
    if [ $? -eq 0 ]; then
        sudo reboot
    fi
}

# Select shell
shell=$(zenity --list --title="Select Shell" --column="Shell" "GNOME" "KDE" "XFCE" "LXDE")

if [ -z "$shell" ]; then
    zenity --info --title="Cancel" --text="Shell selection canceled."
    exit 1
fi

# Determine the path for installing graphics based on the selected shell
case "$shell" in
    "GNOME")
        target_path="/usr/share/gnome-shell/theme"
        ;;
    "KDE")
        target_path="/usr/share/plasma/desktoptheme"
        ;;
    "XFCE")
        target_path="/usr/share/themes"
        ;;
    "LXDE")
        target_path="/usr/share/lxde/themes"
        ;;
    *)
        zenity --error --title="Error" --text="Unknown shell."
        exit 1
        ;;
esac

# Select new graphics
graphics_path=$(zenity --file-selection --title="Select New Graphics" --directory)

if [ -z "$graphics_path" ]; then
    zenity --info --title="Cancel" --text="Graphics selection canceled."
    exit 1
fi

# Remove existing graphics
remove_existing_graphics

# Install new graphics
install_graphics "$graphics_path" "$target_path"
