# dotfiles

Personal configuration for my macOS development environment (also used to provision Linux servers). Files live here and are symlinked into their native locations, so this repo is the single source of truth for shell, editor, terminal, git, and AI-tooling config.

## Layout

### Shells
- **`zsh/`** — Zsh config: custom `functions/` (venv/uv helpers, runpod SSH, greeting, tmpdir) and `scripts/`. See `zsh/README.md`.
- **`bash/`** — Bash config (`.bashrc`, `.inputrc`) structured to work across machines. See `bash/README.md`.
- **`starship.toml`** — [Starship](https://starship.rs/) prompt config.
- **`atuin/`** — [Atuin](https://atuin.sh/) shell history config.

### Terminals & multiplexer
- **`ghostty/`** — Ghostty terminal config.
- **`kitty/`** — Kitty terminal config.
- **`wezterm/`** — WezTerm config.
- **`tmux/`** — tmux config and `popuptmux` helper.

### Editor
- **`nvim/`** — Neovim config (lazy.nvim plugin setup, Lua modules, colorschemes, spell files).

### Version control
- **`git/`** — Git hooks (e.g. `pre-commit`).
- **`jj/`** — [Jujutsu](https://github.com/jj-vcs/jj) VCS config.
- **`hunk/`** — [Hunk](https://github.com/) diff viewer config.

### AI coding tools
- **`claude/`** — Claude Code config: `settings.json`, `CLAUDE.md`, subagents, commands, skills, hooks (branch/push/rm guards), and statusline script.
- **`codex/`** — Codex config: `AGENTS.md`, `config.toml`, agent definitions, and hooks.
- **`pi/`** — Pi agent settings.

### Setup & provisioning
- **`mac-setup/`** — macOS bootstrap script.
- **`setup-proxmox.sh`** — Proxmox/Linux server provisioning script.
- **`scaffolds/`** — Reusable starter files for new projects (`base`, `python` profiles) plus `sp.sh`. See `scaffolds/README.md`.
- **`bin/`** — Standalone scripts (e.g. `gao`, extracts agent/task output from Claude Code JSONL logs).

### Misc
- **`hammerspoon/`** — Hammerspoon (macOS automation) config and Spoons.
- **`yazi/`** — Yazi file manager config.
- **`deprecated/`** — Retired configs kept for reference (fish, goose).

## Usage

Most files are symlinked into place rather than copied — edit them here and changes take effect live. To set up a new machine, start with `mac-setup/setup.sh` (macOS) or `setup-proxmox.sh` (Linux server).
