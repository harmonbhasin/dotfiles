# Bash Configuration Setup

This document explains how to set up bash configuration that works consistently across machines while allowing for machine-specific settings and secrets.

## File Structure Overview

### ~/.bash_profile vs ~/.bashrc

- **`~/.bash_profile`**: Runs for **login shells** (when you SSH in, open terminal app)
- **`~/.bashrc`**: Runs for **non-login shells** (new tabs, subshells, tmux panes)

**Standard pattern**: Put everything in `~/.bashrc` and have `~/.bash_profile` just source it.

## Recommended Setup

### 1. dotfiles/.bashrc (version controlled)
Contains all your common configuration that should be the same across machines:
- Aliases
- Functions  
- Common environment variables
- Tool configurations (fzf, zoxide, etc.)
- History settings

### 2. ~/.bashrc.local (NOT in dotfiles)
Contains machine-specific and sensitive configuration:
- API keys and secrets
- Machine-specific PATH additions
- Tool installations that vary by machine (conda, nvm, etc.)
- Machine-specific aliases

### 3. ~/.bashrc (actual file on each machine)
Simple file that sources both:
```bash
# Source common configuration from dotfiles
source ~/dotfiles/.bashrc

# Source machine-specific configuration if it exists
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
```

### 4. ~/.bash_profile (actual file on each machine)
Just sources ~/.bashrc:
```bash
# Source .bashrc for login shells
[ -f ~/.bashrc ] && source ~/.bashrc
```

## Example Files

### dotfiles/.bashrc (common config)
```bash
# Common bash configuration for all machines
set -o vi

# History settings
export HISTSIZE=-1
export HISTFILESIZE=-1
shopt -s histappend

# Common aliases
alias gs="git status"
alias ll="ls -la"
alias vi=nvim

# Common functions
gwa() {
    # git worktree add function
}

# Tool configurations (if available)
command -v fzf >/dev/null && eval "$(fzf --bash)"
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
```

### ~/.bashrc.local (machine-specific)
```bash
# Machine-specific configuration

# Secrets (NEVER commit these)
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_..."
export OPENAI_API_KEY="sk-..."

# Machine-specific PATH additions
export PATH="$PATH:/home/ec2-user/software/bbmap"
export PATH="$PATH:/opt/quarto/1.5.54/bin"

# Tool initializations that vary by machine
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Conda initialization (if installed)
__conda_setup="$('/home/ec2-user/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
fi
unset __conda_setup

# Machine-specific aliases
alias aws='/usr/local/bin/aws'
```

## Setup Instructions

1. **Create the common config**: Put shared configuration in `dotfiles/.bashrc`

2. **Create machine-specific config**: On each machine, create `~/.bashrc.local` with:
   - API keys and secrets
   - Machine-specific PATH additions
   - Tool installations

3. **Set up the actual ~/.bashrc**:
   ```bash
   echo 'source ~/dotfiles/.bashrc' > ~/.bashrc
   echo '[ -f ~/.bashrc.local ] && source ~/.bashrc.local' >> ~/.bashrc
   ```

4. **Set up ~/.bash_profile**:
   ```bash
   echo '[ -f ~/.bashrc ] && source ~/.bashrc' > ~/.bash_profile
   ```

5. **Reload your shell**:
   ```bash
   source ~/.bashrc
   ```

## Benefits

- ✅ **Consistency**: Common config is identical across machines
- ✅ **Security**: Secrets stay local, never committed
- ✅ **Flexibility**: Each machine can have unique settings
- ✅ **Maintainability**: Update common config in one place
- ✅ **Version control**: Track changes to shared configuration

## Migration from Existing Setup

If you already have configuration in `~/.bashrc` and `~/.bash_profile`:

1. **Extract common parts** to `dotfiles/.bashrc`
2. **Keep machine-specific parts** in `~/.bashrc.local`
3. **Move secrets** from `~/.bash_profile` to `~/.bashrc.local`
4. **Update your actual files** to source both as shown above