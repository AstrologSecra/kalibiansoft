#!/bin/bash

# Variables
REPO_DIR="kalibiansoft"
SECURITY_DIR="$REPO_DIR/security"
EDIT_SYSTEM_DIR="$REPO_DIR/edit_system"
SCRIPT_NAME=$(basename "$0")

# Function to make all .sh scripts executable in a directory, excluding the script itself
make_scripts_executable() {
    local dir=$1
    if [ -d "$dir" ]; then
        echo "Making all .sh scripts executable in $dir..."
        find "$dir" -type f -name "*.sh" ! -name "$SCRIPT_NAME" -exec chmod +x {} \; || { echo "Error making scripts executable in $dir"; exit 1; }
    else
        echo "Directory $dir does not exist. Skipping..."
    fi
}

# Function to install dependencies using apt
install_dependencies_apt() {
    echo "Installing system dependencies (python3 and python3-pip)..."
    sudo apt-get update || { echo "Error updating package list"; exit 1; }
    sudo apt-get install -y python3 python3-pip || { echo "Error installing system dependencies"; exit 1; }

    if [ -f "$REPO_DIR/apt-requirements.txt" ]; then
        echo "apt-requirements.txt found, installing system dependencies..."
        sudo apt-get install -y $(cat "$REPO_DIR/apt-requirements.txt") || { echo "Error installing system dependencies"; exit 1; }
    fi
}

# Function to install dependencies using pacman
install_dependencies_pacman() {
    echo "Installing system dependencies (python and python-pip)..."
    sudo pacman -Syu --noconfirm || { echo "Error updating package list"; exit 1; }
    sudo pacman -S --noconfirm python python-pip || { echo "Error installing system dependencies"; exit 1; }

    if [ -f "$REPO_DIR/pacman-requirements.txt" ]; then
        echo "pacman-requirements.txt found, installing system dependencies..."
        sudo pacman -S --noconfirm $(cat "$REPO_DIR/pacman-requirements.txt") || { echo "Error installing system dependencies"; exit 1; }
    fi
}

# Function to install Python dependencies
install_python_dependencies() {
    if [ -f "$REPO_DIR/python-requirements.txt" ]; then
        echo "python-requirements.txt found, installing Python dependencies..."
        pip install -r "$REPO_DIR/python-requirements.txt" || { echo "Error installing Python dependencies"; exit 1; }
    fi
}

# Function to install Node.js dependencies
install_nodejs_dependencies() {
    if [ -f "$REPO_DIR/package.json" ]; then
        echo "package.json found, installing Node.js dependencies..."
        npm install --prefix "$REPO_DIR" || { echo "Error installing Node.js dependencies"; exit 1; }
    fi
}

# Function to install Ruby dependencies
install_ruby_dependencies() {
    if [ -f "$REPO_DIR/Gemfile" ]; then
        echo "Gemfile found, installing Ruby dependencies..."
        bundle install --gemfile="$REPO_DIR/Gemfile" || { echo "Error installing Ruby dependencies"; exit 1; }
    fi
}

# Function to install PHP dependencies
install_php_dependencies() {
    if [ -f "$REPO_DIR/composer.json" ]; then
        echo "composer.json found, installing PHP dependencies..."
        composer install --working-dir="$REPO_DIR" || { echo "Error installing PHP dependencies"; exit 1; }
    fi
}

# Function to install Rust dependencies
install_rust_dependencies() {
    if [ -f "$REPO_DIR/Cargo.toml" ]; then
        echo "Cargo.toml found, installing Rust dependencies..."
        (cd "$REPO_DIR" && cargo build) || { echo "Error installing Rust dependencies"; exit 1; }
    fi
}

# Function to install Go dependencies
install_go_dependencies() {
    if [ -f "$REPO_DIR/go.mod" ]; then
        echo "go.mod found, installing Go dependencies..."
        (cd "$REPO_DIR" && go mod download) || { echo "Error installing Go dependencies"; exit 1; }
    fi
}

# Function to choose the package manager
choose_package_manager() {
    local choice=$(zenity --list --title="Выбор пакетного менеджера" --text="Выберите пакетный менеджер:" --column="Пакетный менеджер" "apt" "pacman")

    case $choice in
        "apt")
            install_dependencies_apt
            ;;
        "pacman")
            install_dependencies_pacman
            ;;
        *)
            zenity --error --title="Ошибка" --text="Неверный выбор. Выход."
            exit 1
            ;;
    esac
}

# Install dependencies
echo "Installing dependencies..."

# Choose the package manager
choose_package_manager

# Install Python dependencies
install_python_dependencies

# Install Node.js dependencies
install_nodejs_dependencies

# Install Ruby dependencies
install_ruby_dependencies

# Install PHP dependencies
install_php_dependencies

# Install Rust dependencies
install_rust_dependencies

# Install Go dependencies
install_go_dependencies

# Make all .sh scripts executable in the specified directories, excluding the script itself
make_scripts_executable "$SECURITY_DIR"
make_scripts_executable "$EDIT_SYSTEM_DIR"

echo "Dependency installation completed successfully."
