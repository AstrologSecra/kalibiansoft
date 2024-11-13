#!/bin/bash

# ASCII Art for KALIBIAN
print_kalibian_art() {
    echo "  _  __    _    _     ___ ____ ___    _    _   _ "
    echo " | |/ /   / \  | |   |_ _| __ )_ _|  / \  | \ | |"
    echo " | ' /   / _ \ | |    | ||  _ \| |  / _ \ |  \| |"
    echo " | . \  / ___ \| |___ | || |_) | | / ___ \| |\  |"
    echo " |_|\_\/_/   \_\_____|___|____/___/_/   \_\_| \_|"
}

# Print KALIBIAN ASCII Art
print_kalibian_art

# Add the function call to the terminal configuration file
if [ -f ~/.bashrc ]; then
    echo "print_kalibian_art" >> ~/.bashrc
    echo "Added print_kalibian_art to ~/.bashrc"
fi

if [ -f ~/.zshrc ]; then
    echo "print_kalibian_art" >> ~/.zshrc
    echo "Added print_kalibian_art to ~/.zshrc"
fi
