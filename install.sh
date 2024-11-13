#!/bin/bash

# Variables
REPO_DIR="kaltbiansoft"
SECURITY_DIR="$REPO_DIR/security"
EDIT_SYSTEM_DIR="$REPO_DIR/edit_system"
SCRIPT_NAME=$(basename "$0")

# Check if the script is executed from the correct directory
if [ "$(basename "$PWD")" != "$REPO_DIR" ]; then
    echo "Please run this script from the $REPO_DIR directory."
    exit 1
fi

# Function to make all .sh scripts executable in a directory, excluding the script itself
make_scripts_executable() {
    local dir=$1
    echo "Making all .sh scripts executable in $dir..."
    find "$dir" -type f -name "*.sh" ! -name "$SCRIPT_NAME" -exec chmod +x {} \; || { echo "Error making scripts executable in $dir"; exit 1; }
}

# Install dependencies
echo "Installing dependencies..."

# Install system dependencies (python3 and python3-pip)
echo "Installing system dependencies (python3 and python3-pip)..."
sudo apt-get update || { echo "Error updating package list"; exit 1; }
sudo apt-get install -y python3 python3-pip || { echo "Error installing system dependencies"; exit 1; }

# Check for the presence of apt-requirements.txt
if [ -f "apt-requirements.txt" ]; then
    echo "apt-requirements.txt found, installing system dependencies..."
    sudo apt-get install -y $(cat apt-requirements.txt) || { echo "Error installing system dependencies"; exit 1; }
fi

# Check for the presence of python-requirements.txt (for Python)
if [ -f "python-requirements.txt" ]; then
    echo "python-requirements.txt found, installing Python dependencies..."
    pip install -r python-requirements.txt || { echo "Error installing Python dependencies"; exit 1; }
fi

# Check for the presence of package.json (for Node.js)
if [ -f "package.json" ]; then
    echo "package.json found, installing Node.js dependencies..."
    npm install || { echo "Error installing Node.js dependencies"; exit 1; }
fi

# Check for the presence of Gemfile (for Ruby)
if [ -f "Gemfile" ]; then
    echo "Gemfile found, installing Ruby dependencies..."
    bundle install || { echo "Error installing Ruby dependencies"; exit 1; }
fi

# Check for the presence of composer.json (for PHP)
if [ -f "composer.json" ]; then
    echo "composer.json found, installing PHP dependencies..."
    composer install || { echo "Error installing PHP dependencies"; exit 1; }
fi

# Check for the presence of Cargo.toml (for Rust)
if [ -f "Cargo.toml" ]; then
    echo "Cargo.toml found, installing Rust dependencies..."
    cargo build || { echo "Error installing Rust dependencies"; exit 1; }
fi

# Check for the presence of go.mod (for Go)
if [ -f "go.mod" ]; then
    echo "go.mod found, installing Go dependencies..."
    go mod download || { echo "Error installing Go dependencies"; exit 1; }
fi

# Make all .sh scripts executable in the specified directories, excluding the script itself
make_scripts_executable "$SECURITY_DIR"
make_scripts_executable "$EDIT_SYSTEM_DIR"

echo "Dependency installation completed successfully."
