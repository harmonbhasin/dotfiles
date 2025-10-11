# ABOUTME: Vanilla Zsh configuration with manually managed plugins

# ===== ENVIRONMENT SETUP =====
# Ghostty integration
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# ===== BASIC ZSH OPTIONS =====
# Core zsh options that Oh My Zsh was handling
setopt AUTO_CD                 # cd by typing directory name if it's not a command
setopt AUTO_PUSHD              # Make cd push old directory to directory stack
setopt PUSHD_IGNORE_DUPS       # Don't push multiple copies of same dir to stack
setopt PUSHD_SILENT            # Don't print directory stack after pushd/popd
setopt CORRECT                 # Command correction
setopt EXTENDED_GLOB           # Extended globbing
setopt GLOB_DOTS               # Include dotfiles in glob patterns
setopt HIST_EXPIRE_DUPS_FIRST  # Delete duplicates first when HISTFILE size > HISTSIZE
setopt HIST_IGNORE_DUPS        # Don't record duplicate commands
setopt HIST_IGNORE_SPACE       # Don't record commands that start with space
setopt HIST_VERIFY             # Show command with history expansion before running
setopt INC_APPEND_HISTORY      # Save commands to history file immediately
setopt SHARE_HISTORY           # Share history between all sessions

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Completion system
autoload -U compinit
compinit

# ===== PLUGIN LOADING =====
# Load zsh-autocomplete first (must be early, before compdef calls)
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Load other plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Editor
export EDITOR="nvim"

# Vi mode (equivalent to fish_vi_key_bindings)
bindkey -v
bindkey '^ ' autosuggest-accept

# ===== ALIASES =====
# Personal aliases
alias vi="nvim"
alias v="nvim"
alias vs="nvim --listen /tmp/nvim"
alias vc='nvim $(git diff --name-only HEAD)'
alias change-ec2="/Users/harmonbhasin/work/securebio/instance_manipulator.sh"
alias check-ec2="/Users/harmonbhasin/work/securebio/check_ec2.sh"
alias start-ec2="/Users/harmonbhasin/work/securebio/start_ec2.sh"
alias stop-ec2="/Users/harmonbhasin/work/securebio/stop_ec2.sh"
alias grab-ec2="/Users/harmonbhasin/work/securebio/grab_ec2.sh"
alias list-ec2="/Users/harmonbhasin/work/securebio/list_harmon_instances.sh"
alias claude="/Users/harmonbhasin/.claude/local/claude"
alias c="/Users/harmonbhasin/.claude/local/claude"
alias d="nvim -c ':ObsidianToday'"
alias llm-conf="cd ~/Library/Application\ Support/io.datasette.llm/"

# Tmux aliases
alias t=tmux
alias ta="tmux attach"

# Git aliases
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias gw="git worktree"
alias gwl="git worktree list"
alias gst="git stash"
alias gstl="git stash list"
alias gha="git stash apply"
alias gs="git status"
alias gr="git restore"
alias grs="git restore --staged"
alias grbc="git rebase --continue"
alias gl="git log --oneline"
alias gb="git branch"
alias gpl="git pull origin"
alias ga="git add"
alias gap="git add --patch"
alias gclf="git clean -f"
alias gc="git commit -m"
alias gca="git commit --amend --no-edit"
alias gpu="git push origin"
alias gpom="git push origin main"
alias gd="git diff"
alias gds="git diff --staged"

alias l="ls -la"
alias x="exit"

# RunPod aliases
alias runpodtouch="runpodctl create pod --gpuType 'NVIDIA RTX A4500' --imageName 'runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04' --ports '22/tcp' --ports '8888/http' --volumeSize 50 --containerDiskSize 30 --volumePath '/workspace' --secureCloud"
alias runpodcp="runpodctl get pod | awk 'NR==2 {print \$1}' | pbcopy && runpodctl get pod"
alias runpodrm="runpodctl remove pod"

# ===== EXTERNAL INTEGRATIONS =====
# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Load all function files
for file in $HOME/dotfiles/zsh/functions/*.zsh; do
  [ -f "$file" ] && source "$file"
done

# Execute greeting on startup (equivalent to fish_greeting)
#[ -f "$HOME/dotfiles/zsh/functions/greeting.zsh" ] && greeting

# Starship prompt if installed
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Source local env file
if [ -f "$HOME/.local/bin/env.zsh" ]; then
  source "$HOME/.local/bin/env.zsh"
fi

# Conda initialization
__conda_setup="$('/Users/harmonbhasin/programming/software/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/harmonbhasin/programming/software/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/harmonbhasin/programming/software/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/harmonbhasin/programming/software/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

# Disable conda's auto prompt modification (Starship handles it)
export CONDA_CHANGEPS1=false

# Source env
envsource ~/.env

# Yazi integration
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Obsidian sync - open, wait for sync, then close
osync() {
	local sync_time=${1:-5}  # Default 10 seconds, can pass custom time as argument

	echo "Opening Obsidian..."
	open -a Obsidian

	echo "Waiting ${sync_time} seconds for sync..."
	sleep "$sync_time"

	echo "Closing Obsidian..."
	osascript -e 'quit app "Obsidian"'

	echo "Sync complete!"
}

# Additional PATH exports
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export TVM_LIBRARY_PATH=/Users/harmonbhasin/programming/software/tvm/build
export TVM_HOME=/Users/harmonbhasin/programming/software/tvm/build
export PYTHONPATH=$TVM_HOME/python:$PYTHONPATH
export PIP_REQUIRE_VIRTUALENV=false
export TERM=xterm-ghostty

# Atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# LM Studio
export PATH="$PATH:/Users/harmonbhasin/.lmstudio/bin"

# OCaml/Opam
[[ ! -r '/Users/harmonbhasin/.opam/opam-init/init.zsh' ]] || source '/Users/harmonbhasin/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

# Zoxide
eval "$(zoxide init zsh)"

# GHCup
[ -f "/Users/harmonbhasin/.ghcup/env" ] && . "/Users/harmonbhasin/.ghcup/env"

# Terraform completion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Colors
export CLICOLOR=1

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up jj key bindings
source <(COMPLETE=zsh jj)

# Ripgrep configuration
#export RIPGREP_CONFIG_PATH="$HOME/dotfiles/.ripgreprc"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
