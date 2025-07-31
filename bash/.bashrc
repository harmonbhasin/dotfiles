# .bashrc

# Vim keybindings
set -o vi

# History settings
export HISTSIZE=-1         # Unlimited commands in memory per session
export HISTFILESIZE=-1     # Unlimited commands in the history file
shopt -s histappend        # Append to history file, don't overwrite
export HISTTIMEFORMAT="%d/%m/%y %T " # Timestamp format
# Synchronize history across multiple sessions (e.g., tmux, multiple tabs); Set the cursor to steady bar (|) cursor
export PROMPT_COMMAND='history -a; history -c; history -r;echo -ne "\e[6 q"'

# Get colors in terminal
export CLICOLOR=1
# Set default editor
export EDITOR=nvim
# Set default terminal color
export TERM=xterm-256color

# Add a worktree for a new or existing branch
gwa () {
    local branch=$1
    local path=${2:-../$branch}

    if [[ -z $branch ]]; then
        echo "Usage: gwa <branch> [path]"
        return 1
    fi

    # If that path is already registered as a worktree, do nothing
    if git worktree list --porcelain | grep -q "^worktree $(
            realpath -m "$path" 2>/dev/null || echo "$path"
        )$"; then
        echo "Worktree already exists at $path"
        return 0
    fi

    # If the branch already exists, check it out; otherwise create it
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        echo "Adding worktree for existing branch '$branch' → $path"
        git worktree add "$path" "$branch"
    else
        echo "Branch '$branch' does not exist – creating it in $path"
        git worktree add -b "$branch" "$path"
    fi
}

# Remove a worktree (and optionally delete the branch if it no longer has checkouts)
gwr () {
    local branch=$1
    local path=${2:-../$branch}

    if [[ -z $branch ]]; then
        echo "Usage: gwr <branch> [path]"
        return 1
    fi

    # Remove the worktree directory if it is registered
    if git worktree list --porcelain | grep -q "^worktree $(
            realpath -m "$path" 2>/dev/null || echo "$path"
        )$"; then
        echo "Removing worktree $path"
        git worktree remove "$path" --force
    else
        echo "No worktree registered at $path"
    fi

    # Try to delete the local branch (ignore if unmerged)
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        git branch -D "$branch" 2>/dev/null || \
        echo "Branch '$branch' not fully merged; remove manually with 'git branch -D $branch' if desired."
    fi

    # Clean up any stale worktree refs
    git worktree prune --verbose
}

# Claude yolo
ccv() {
  # 1. Environment variables to set just for the `claude` invocation
  local -a env_vars=(
    ENABLE_BACKGROUND_TASKS=true
    FORCE_AUTO_BACKGROUND_TASKS=true
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=true
    CLAUDE_CODE_ENABLE_UNIFIED_READ_TOOL=true
  )

  # 2. Collect extra CLI flags for `claude`
  local -a claude_args=()

  case "$1" in
    -y)   claude_args+=(--dangerously-skip-permissions); shift ;;
    -r)   claude_args+=(--resume);                       shift ;;
    -ry|-yr)
          claude_args+=(--resume --dangerously-skip-permissions); shift ;;
  esac

  # 3. Run `claude` with env vars and any remaining args
  env "${env_vars[@]}" claude "${claude_args[@]}" "$@"
}

# User prompt stuff
# Function to get git branch and status
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Define colors
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
YELLOW="\[\033[0;33m\]"
NC="\[\033[0m\]" # No Color

# The PS1 prompt variable
PS1="${GREEN}\u@\h${NC}:${BLUE}\w${YELLOW}\$(parse_git_branch)${NC}\n❯ "

# General aliases
alias lsa='ls -la'
alias clear="clear -x"

# Tmux aliases
alias t=tmux
alias ta="tmux attach"

# Git aliases
alias gwa=gwa
alias gwr=gwr
alias gwl="git worktree list"
alias gh="git stash"
alias ghl="git stash list"
alias gha="git stash apply"
alias gs="git status"
alias gr="git restore"
alias grs="git restore --staged"
alias gl="git log --oneline"
alias gb="git branch"
alias gpl="git pull origin"
alias ga="git add"
alias gclf="git clean -f"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gpu="git push origin"
alias gpom="git push origin main"
alias gd="git diff"
alias gds="git diff --staged"

# Editor aliases
alias vi=nvim
alias v=nvim
alias vim=nvim

# fzf aliases
eval "$(fzf --bash)"
alias sd="cd \$(find . -type d | fzf)" #already exists bruh alt + c; not exactly, as this looks for file, then brings you to that dir
alias fz='readlink -f "$(fzf)"'

# claude alias
alias ccv=ccv

# zoxide; needs to be at bottom of file if i'm remembering correctly
#eval "$(zoxide init bash)"
