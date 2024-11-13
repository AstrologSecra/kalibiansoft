#!/bin/bash

# ASCII Art for KALIBIAN
print_kalibian_art() {
    cat << "EOF"
  _  __    _    _     ___ ____ ___    _    _   _ 
 | |/ /   / \  | |   |_ _| __ )_ _|  / \  | \ | |
 | ' /   / _ \ | |    | ||  _ \| |  / _ \ |  \| |
 | . \  / ___ \| |___ | || |_) | | / ___ \| |\  |
 |_|\_\/_/   \_\_____|___|____/___/_/   \_\_| \_|
EOF
}

# Add the function call to the terminal configuration file
if [ -f ~/.bashrc ]; then
    echo "print_kalibian_art" >> ~/.bashrc
    echo "Added print_kalibian_art to ~/.bashrc"
fi

if [ -f ~/.zshrc ]; then
    echo "print_kalibian_art" >> ~/.zshrc
    echo "Added print_kalibian_art to ~/.zshrc"
fi
