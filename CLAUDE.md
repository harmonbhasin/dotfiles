# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This repository contains personal configuration settings for various development tools:

- `claude/`: Claude AI configurations
- `codex/`: Codex configurations 
- `fish/`: Fish shell configurations
- `ghostty/`: Terminal emulator configurations
- `goose/`: Goose (OpenAI/AI helper) configurations
- `nvim/`: Neovim configurations
- `yazi/`: File manager configurations
- `zsh/`: Zsh shell configurations

## Shell Environment

The repository contains configurations for both Fish shell and Zsh:

### Fish Shell

Fish is configured with:
- Custom functions for virtual environments, temporary directories
- Plugins for Node version management
- Python environment management
- Editor configuration (set to Neovim)
- Virtual environment integration

### Zsh

The repository includes Zsh configurations with:
- Plugin support (auto-suggestions, syntax highlighting)
- Custom functions for environment management
- Integration with Oh-My-Zsh

## Neovim Configuration

The Neovim setup is quite extensive, featuring:

- Lazy.nvim for plugin management
- LSP integration for Python, TypeScript, R, etc.
- Rich tooling for debugging (nvim-dap)
- Treesitter for syntax highlighting
- Integration with Notion, Obsidian, Quarto
- Terminal integration
- Custom keymappings for efficient navigation
- AI-assisted coding with CodeCompanion and Codeium

## Terminal and UI Tools

- Ghostty: Terminal emulator with custom keybindings and theme 
- Starship: Cross-shell prompt with customized icons
- Yazi: TUI file manager with custom settings

## AI Tools Integration

- Claude: AI assistant with custom settings and commands
- Goose: OpenAI integration with Computer Controller and Developer extensions
- CodeCompanion: Neovim integration for AI-assisted coding
- Codeium: AI code completion

## Common Development Tasks

### Setting Up New Environments

For setting up new Zsh environments:
```bash
cd zsh
./install.sh
```

### Shell Functions

Several useful shell functions are defined:
- `venv.fish`/`venv.zsh`: Virtual environment management
- `tmpdir.fish`/`tmpdir.zsh`: Temporary directory creation and management
- `envsource.fish`/`envsource.zsh`: Source environment variables

### Neovim Usage

Notable Neovim keybindings:
- `<leader>ff`: Find files (Telescope)
- `<leader>/`: Live grep (Telescope)
- `<leader>o`: Buffer list
- `<leader>aa`: Toggle Code Companion Chat
- `<leader>nm`: Open Notion menu
- `<leader>e`: Toggle Harpoon menu
- `<leader>-`: Open Yazi file manager
- `<leader>db`: Toggle debug breakpoint
- `<leader>rr`: Toggle REPL

## Important Notes

1. The configuration assumes certain tools are installed on the system
2. Neovim configuration depends on a variety of plugins that are installed with lazy.nvim
3. The Claude settings are minimal and allow only specific Bash commands
4. The repository integrates multiple AI tools for different purposes

When modifying these files, maintain the existing structure and patterns, and test changes thoroughly before committing them.