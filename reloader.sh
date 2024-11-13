#!/bin/bash

# Define the home directory
HOME_DIR="$HOME"

# Remove the ossoft directory if it exists in the home directory
if [ -d "$HOME_DIR/ossoft" ]; then
  echo "Removing ossoft directory from home directory..."
  rm -rf "$HOME_DIR/ossoft"
  echo "ossoft directory removed."
else
  echo "ossoft directory does not exist in home directory."
fi

# Clone the repository into the home directory
echo "Cloning repository https://github.com/AstrologSecra/ossoft into home directory..."
git clone https://github.com/AstrologSecra/ossoft "$HOME_DIR/ossoft"
echo "Repository cloned."
