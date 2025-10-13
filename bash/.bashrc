# .bashrc

# Vim keybindings
set -o vi

# Less settings
export LESS="-JMQRSi"

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

# spelling
shopt -s nocaseglob # ignore case when matching
shopt -s cdspell # fix common spelling mistakes

# autocd
shopt -s autocd

# go to root of project in git dir; https://blog.meain.io/2023/navigating-around-in-shell/
r () {
cd "$(git rev-parse --show-toplevel 2>/dev/null)"
}

# tmp dir; https://blog.meain.io/2023/navigating-around-in-shell/
tmp () {
[ "$1" = "view" ] && cd /tmp/workspaces && cd $(ls -t | fzf --preview 'ls -A {}') && return 0
r="/tmp/workspaces/$(xxd -l3 -ps /dev/urandom)"
mkdir -p -p "$r" && pushd "$r"
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
alias l='ls -lah'
alias clear="clear -x"

# Tmux aliases
alias t=tmux
alias ta="tmux attach"

# Git autocomplete
source /usr/share/bash-completion/completions/git

# Load inputrc
bind -f ~/dotfiles/bash/.inputrc

# Git aliases + completions
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias gwl="git worktree list"
alias gw="git worktree"
__git_complete gw _git_worktree
alias gst="git stash"
__git_complete gst _git_stash
alias gstl="git stash list"
alias gsa="git stash apply"
alias gs="git status"
__git_complete gs _git_status
alias gr="git restore"
__git_complete gr _git_restore
alias grs="git restore --staged"
alias grbc="git rebase --continue"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gb="git branch"
__git_complete gb _git_branch
alias gpl="git pull origin"
alias ga="git add"
__git_complete ga _git_add
alias gap="git add --patch"
alias gclf="git clean -f"
alias gc="git commit -m"
alias gca="git commit --amend --no-edit"
alias gpu="git push origin"
alias gpom="git push origin main"
alias gd="git diff"
__git_complete gd _git_diff
alias gds="git diff --staged"

# Editor aliases
alias vi=nvim
alias v=nvim
alias vim=nvim
alias vl="nvim --listen /tmp/nvim"
alias vc='nvim $(git diff --name-only HEAD)'

# fzf aliases
eval "$(fzf --bash)"
alias sd="cd \$(find . -type d | fzf)" #already exists bruh alt + c; not exactly, as this looks for file, then brings you to that dir
alias fz='readlink -f "$(fzf)"'

# claude alias
alias ccv=ccv

# exit alias
alias x="exit"

# last opened file
alias la='nvim "$(ls -tu --time=atime | head -n1)"'

# work alias
s3fetch() {
    sed 's|/fusion/s3/|s3://|' "$1" | xargs -P 1 -I {} aws s3 cp {} ./
}

# PR comments function - get comments for a PR by number
pr() {
    # Check if PR number was provided
    if [ -z "$1" ]; then
        echo "Usage: pr <PR_NUMBER>"
        return 1
    fi

    # Get the GitHub remote URL
    local remote_url=$(git remote get-url origin 2>/dev/null)
    if [ -z "$remote_url" ]; then
        echo "Error: Not in a git repository or no 'origin' remote found"
        return 1
    fi

    # Extract owner and repo from the remote URL
    # Handle both SSH and HTTPS URLs
    if [[ "$remote_url" =~ git@github.com:([^/]+)/(.+)\.git ]]; then
        # SSH format
        local owner="${BASH_REMATCH[1]}"
        local repo="${BASH_REMATCH[2]}"
    elif [[ "$remote_url" =~ https://github.com/([^/]+)/(.+)(\.git)?$ ]]; then
        # HTTPS format
        local owner="${BASH_REMATCH[1]}"
        local repo="${BASH_REMATCH[2]%.git}"  # Remove .git if present
    else
        echo "Error: Could not parse GitHub repository from remote URL"
        return 1
    fi

    # Get the PR comments using gh api
    gh api "repos/$owner/$repo/pulls/$1/comments"
}


# zoxide; needs to be at bottom of file if i'm remembering correctly
#eval "$(zoxide init bash)"
