#!/bin/bash
# Convert fish environment file to zsh format

FISH_ENV="$HOME/.local/bin/env.fish"
ZSH_ENV="$HOME/.local/bin/env.zsh"

if [ ! -f "$FISH_ENV" ]; then
    echo "Fish environment file not found at $FISH_ENV"
    exit 1
fi

# Make directory if it doesn't exist
mkdir -p "$(dirname "$ZSH_ENV")"

# Convert fish environment variables to zsh format
echo "# Converted from fish environment variables" > "$ZSH_ENV"

while IFS= read -r line; do
    # Skip comments and empty lines
    if [[ $line =~ ^# || -z "$line" ]]; then
        echo "$line" >> "$ZSH_ENV"
        continue
    fi
    
    # Convert fish set -x VAR VALUE to zsh export VAR=VALUE
    if [[ $line =~ ^set\ +(-x|-gx|--export|--global\ --export)\ +([A-Za-z0-9_]+)\ +(.*) ]]; then
        var_name="${BASH_REMATCH[2]}"
        var_value="${BASH_REMATCH[3]}"
        echo "export $var_name=\"$var_value\"" >> "$ZSH_ENV"
    # Convert fish_add_path to PATH addition
    elif [[ $line =~ fish_add_path ]]; then
        # Extract the path from the line
        if [[ $line =~ fish_add_path\ +(-g|-p|--global|--prepend|--move)*\ +(.*) ]]; then
            path_to_add="${BASH_REMATCH[2]}"
            echo "export PATH=\"$path_to_add:\$PATH\"" >> "$ZSH_ENV"
        fi
    else
        # Comment out any lines we don't know how to convert
        echo "# FISH: $line" >> "$ZSH_ENV"
    fi
done < "$FISH_ENV"

echo "Converted $FISH_ENV to $ZSH_ENV"