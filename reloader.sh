#!/bin/bash

# Remove the ossoft directory if it exists
if [ -d "ossoft" ]; then
  echo "Removing ossoft directory..."
  rm -rf ossoft
  echo "ossoft directory removed."
else
  echo "ossoft directory does not exist."
fi

# Clone the repository
echo "Cloning repository https://github.com/AstrologSecra/ossoft..."
git clone https://github.com/AstrologSecra/ossoft
echo "Repository cloned."
