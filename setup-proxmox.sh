#!/bin/bash
set -e

echo "=== Proxmox Server Setup ==="

#################
# System packages
#################

apt update

# Brendan Gregg's Linux crisis tools
# https://www.brendangregg.com/blog/2024-03-24/linux-crisis-tools.html
apt install -y \
    procps \
    util-linux \
    sysstat \
    iproute2 \
    numactl \
    tcpdump \
    linux-tools-common \
    bpfcc-tools \
    bpftrace \
    trace-cmd \
    nicstat \
    ethtool \
    tiptop \
    cpuid \
    msr-tools

# General dev tools
apt install -y \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    vim \
    gh \
    ripgrep \
    fzf \
    tmux \
    htop \
    lsof \
    net-tools \
    iperf3 \
    jq \
    strace \
    zoxide \
    tree \
    fd-find

#################
# Locale
#################

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

#################
# UV (Python)
#################

curl -LsSf https://astral.sh/uv/install.sh | sh

#################
# NVM + Node.js
#################

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 22
nvm use 22

#################
# Neovim (latest)
#################

NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.tag_name')
curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
tar -xzf nvim-linux-x86_64.tar.gz
rm -rf /opt/nvim-linux-x86_64
mv nvim-linux-x86_64 /opt/
rm nvim-linux-x86_64.tar.gz

#################
# NPM global packages
#################

npm install -g @anthropic-ai/claude-code
npm install -g tldr

#################
# Dotfiles
#################

DOTFILES="$HOME/dotfiles"

# Symlink configs
mkdir -p ~/.config

ln -sf "$DOTFILES/nvim" ~/.config/nvim
ln -sf "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig

echo "=== Setup complete ==="
echo "Run 'source ~/.bashrc' or start a new shell"
