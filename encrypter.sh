#!/bin/bash

# Function to encrypt files
encrypt_files() {
    echo "Encrypting files..."
    for file in *; do
        if [ -f "$file" ] && [ "$file" != "$0" ]; then
            openssl enc -aes-256-cbc -salt -in "$file" -out "$file.enc" -pass pass:"$ENCRYPTION_KEY"
        fi
    done
    echo "Files encrypted."
}

# Function to decrypt files
decrypt_files() {
    echo "Decrypting files..."
    for file in *.enc; do
        if [ -f "$file" ]; then
            original_file="${file%.enc}"
            openssl enc -d -aes-256-cbc -in "$file" -out "$original_file" -pass pass:"$DECRYPTION_KEY"
        fi
    done
    echo "Files decrypted."
}

# Function to generate a 5-character decryption key
generate_decryption_key() {
    DECRYPTION_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
    echo "Decryption key: $DECRYPTION_KEY"
}

# Function to clear the terminal
clear_terminal() {
    clear
}

# Main logic of the script
if [ "$1" == "encrypt" ]; then
    generate_decryption_key
    read -p "Continue with encryption? (y/n): " confirm
    if [ "$confirm" == "y" ]; then
        read -p "Enter the encryption password: " ENCRYPTION_KEY
        encrypt_files
        clear_terminal
        echo "Files encrypted. Please enter the decryption key to decrypt them."
        read -p "Enter the 5-character decryption key: " DECRYPTION_KEY
        if [ ${#DECRYPTION_KEY} -eq 5 ]; then
            decrypt_files
        else
            echo "Invalid decryption key. It must be 5 characters long."
        fi
    else
        echo "Encryption canceled."
    fi
elif [ "$1" == "decrypt" ]; then
    read -p "Enter the 5-character decryption key: " DECRYPTION_KEY
    if [ ${#DECRYPTION_KEY} -eq 5 ]; then
        decrypt_files
    else
        echo "Invalid decryption key. It must be 5 characters long."
    fi
else
    echo "Usage: $0 {encrypt|decrypt}"
fi
