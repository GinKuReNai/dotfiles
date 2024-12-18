#!/bin/bash

# エラーハンドリング
set -euo pipefail

# スクリプトのディレクトリを取得
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)

# ~/.configディレクトリを作成
CONFIG_DIR="$HOME/.config"
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating $CONFIG_DIR..."
    mkdir -p "$CONFIG_DIR"
else
    echo "$CONFIG_DIR already exists."
fi

# デフォルトのシェルをzshに変更
chsh -s $(which zsh)

# nvimディレクトリのシンボリックリンクを作成
NVIM_SOURCE="$SCRIPT_DIR/nvim"
NVIM_TARGET="$CONFIG_DIR/nvim"
if [ -e "$NVIM_TARGET" ]; then
    echo "$NVIM_TARGET already exists. Skipping symlink creation."
else
    echo "Creating symlink for nvim: $NVIM_SOURCE -> $NVIM_TARGET"
    ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
fi

# tmuxディレクトリのシンボリックリンクを作成
TMUX_SOURCE="$SCRIPT_DIR/tmux"
TMUX_TARGET="$CONFIG_DIR/tmux"
if [ -e "$TMUX_TARGET" ]; then
    echo "$TMUX_TARGET already exists. Skipping symlink creation."
else
    echo "Creating symlink for tmux: $TMUX_SOURCE -> $TMUX_TARGET"
    ln -s "$TMUX_SOURCE" "$TMUX_TARGET"
fi

# Homebrewのインストール
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Brewfileを用いたbrew bundleの実行
BREWFILE="$SCRIPT_DIR/.Brewfile"
if [ -f "$BREWFILE" ]; then
    echo "Running brew bundle using $BREWFILE..."
    brew bundle --file="$BREWFILE"
else
    echo "Error: $BREWFILE not found. Skipping brew bundle."
fi

# /opt/homebrew/shareの権限変更
chmod -R go-w /opt/homebrew/share

echo "Setup complete!"
