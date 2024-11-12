#!/bin/bash

# Process arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r|--random) random=1 ;;
        -l|--letters) letters=1 ;;
        -n|--numbers) numbers=1 ;;
        -s|--special) special=1 ;;
        -h|--help) help=1 ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
    shift
done

# Display help
if [[ "$help" == 1 ]]; then
    echo "Usage: $0 [options]"
    echo "  -r, --random    Generate a password with random length between 6 and 16 characters"
    echo "  -l, --letters   Use letters in the password"
    echo "  -n, --numbers   Use numbers in the password"
    echo "  -s, --special   Use special characters in the password"
    echo "  -h, --help      Show this help message"
    exit 0
fi

# Define characters for password generation
chars=""
if [[ "$letters" == 1 ]]; then
    chars+="A-Za-z"
fi
if [[ "$numbers" == 1 ]]; then
    chars+="0-9"
fi
if [[ "$special" == 1 ]]; then
    chars+="!@#$%^&*()_+[]{}|;:,.<>?~"
fi

# Check if no character types are selected
if [[ -z "$chars" ]]; then
    echo "Error: No character types selected. Use at least one of -l, -n, or -s."
    exit 1
fi

# Generate random length if -r is specified
if [[ "$random" == 1 ]]; then
    length=$((RANDOM % 11 + 6))
else
    echo "Error: The -r option is required for random length generation."
    exit 1
fi

# Generate password
password=$(tr -dc "$chars" < /dev/urandom | head -c "$length")

# Output password
echo "Generated password: $password"
