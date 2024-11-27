#!/bin/bash

# Function to remove existing graphics and shells using apt
remove_existing_graphics_and_shells_apt() {
    # List of graphics and shell packages that may be installed
    local packages=("xorg" "xserver-xorg" "x11-common" "x11-utils" "x11-xserver-utils" "x11-xkb-utils" "x11-apps" "x11-session-utils" "x11-xfs-utils" "x11-xinit-session" "x11-xdm-session" "x11-xdm-theme" "x11-xdm-theme-default" "x11-xdm-theme-gnome" "x11-xdm-theme-kde" "x11-xdm-theme-xfce" "x11-xdm-theme-lxde"
                    "gnome" "gnome-shell" "gnome-session" "gnome-core" "gnome-desktop" "gnome-settings-daemon" "gnome-terminal" "gnome-control-center"
                    "kde-full" "kde-plasma-desktop" "kde-standard" "kde-runtime" "kde-workspace" "kde-baseapps" "kde-base-artwork"
                    "xfce4" "xfce4-goodies" "xfce4-session" "xfce4-panel" "xfce4-settings" "xfce4-terminal"
                    "lxde" "lxde-core" "lxde-common" "lxde-icon-theme" "lxde-settings-daemon" "lxde-session" "lxterminal")

    # Remove packages
    for package in "${packages[@]}"; do
        if dpkg -l | grep -q "^ii  $package"; then
            sudo apt-get remove --purge -y "$package"
        fi
    done

    # Autoremove unnecessary packages
    sudo apt-get autoremove -y
}

# Function to remove existing graphics and shells using pacman
remove_existing_graphics_and_shells_pacman() {
    # List of graphics and shell packages that may be installed
    local packages=("xorg" "xorg-server" "xorg-xinit" "xorg-apps" "xorg-xdm" "xorg-xdm-theme" "xorg-xdm-theme-default" "xorg-xdm-theme-gnome" "xorg-xdm-theme-kde" "xorg-xdm-theme-xfce" "xorg-xdm-theme-lxde"
                    "gnome" "gnome-shell" "gnome-session" "gnome-core" "gnome-desktop" "gnome-settings-daemon" "gnome-terminal" "gnome-control-center"
                    "kde-full" "plasma-desktop" "kde-standard" "kde-runtime" "kde-workspace" "kde-baseapps" "kde-base-artwork"
                    "xfce4" "xfce4-goodies" "xfce4-session" "xfce4-panel" "xfce4-settings" "xfce4-terminal"
                    "lxde" "lxde-core" "lxde-common" "lxde-icon-theme" "lxde-settings-daemon" "lxde-session" "lxterminal")

    # Remove packages
    for package in "${packages[@]}"; do
        if pacman -Q | grep -q "^$package "; then
            sudo pacman -Rns --noconfirm "$package"
        fi
    done

    # Autoremove unnecessary packages
    sudo pacman -Rns --noconfirm $(pacman -Qdtq)
}

# Function to choose the package manager
choose_package_manager() {
    local choice=$(zenity --list --title="Choose Package Manager" --text="Select the package manager to use:" --column="Package Manager" "apt" "pacman")

    case $choice in
        "apt")
            remove_existing_graphics_and_shells_apt
            ;;
        "pacman")
            remove_existing_graphics_and_shells_pacman
            ;;
        *)
            zenity --error --title="Error" --text="No valid choice selected. Exiting."
            exit 1
            ;;
    esac
}

# Choose the package manager
choose_package_manager

# Reboot the computer
zenity --question --title="Reboot" --text="Graphics and shells successfully removed. Reboot the computer now?"
if [ $? -eq 0 ]; then
    sudo reboot
fi
