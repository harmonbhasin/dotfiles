# Environment variables
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export GOPATH="$HOME/go"
export EDITOR="nvim"
export PIP_REQUIRE_VIRTUALENV=true

# Goose
export GOOSE_PLANNER_PROVIDER=google
export GOOSE_PLANNER_MODEL=gemini-2.5-pro-exp-03-25

# Add Python 3.13 to PATH
export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"

# Add local bin directory to PATH (for llm, goose, etc.)
export PATH="$HOME/.local/bin:$PATH"
. "$HOME/.cargo/env"
