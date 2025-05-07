#!/bin/bash
# Setup script for zsh configuration

DOTFILES_DIR="$HOME/dotfiles"
ZSH_DIR="$DOTFILES_DIR/zsh"

# Create symlinks
echo "Creating symlinks for zsh configuration..."

# Create ~/.zsh directory if it doesn't exist
mkdir -p ~/.zsh

# Create symlinks for main config files
ln -sf "$ZSH_DIR/.zshrc" ~/.zshrc
ln -sf "$ZSH_DIR/.zshenv" ~/.zshenv

# Create symlinks for functions and completions
ln -sf "$ZSH_DIR/functions" ~/.zsh/
ln -sf "$ZSH_DIR/completions" ~/.zsh/

# Run the environment conversion script if it exists
if [ -f "$ZSH_DIR/scripts/convert_env.sh" ]; then
    echo "Converting fish environment variables to zsh format..."
    "$ZSH_DIR/scripts/convert_env.sh"
fi

echo "Zsh configuration has been set up successfully."
echo "To activate the new configuration, run: 'source ~/.zshrc'"