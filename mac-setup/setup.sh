ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install fzf
brew install neovim
brew install atuin
brew install oxide
brew install jj
brew install tmux
brew install gh
brew install tree-sitter
brew install rg
brew install delta
brew install raycast
brew install glide
glide launch

mkdir ~/.nvm
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install 22
nvm use 22

curl -fsSL https://claude.ai/install.sh | bash
npm i -g @openai/codex

npm install -g tree-sitter-cli

mkdir -p ~/.config
mkdir -p ~/.claude
mkdir -p ~/.codex
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sfn ~/dotfiles/claude/commands ~/.claude/commands
ln -sfn ~/dotfiles/claude/agents ~/.claude/agents
ln -sfn ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -sfn ~/dotfiles/claude/statusline-command.sh ~/.claude/statusline-command.sh

ln -s ~/dotfiles/tmux/.tmux.conf ~/

ln -sfn ~/dotfiles/claude/CLAUDE.md ~/.codex/AGENTS.md
ln -sfn ~/dotfiles/codex/config.toml ~/.codex/config.toml

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
