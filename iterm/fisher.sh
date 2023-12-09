#!/bin/sh

# fishのパッケージマネージャ `fisher` のインストール
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# fishのテーマとして bobthefish を追加
fisher install oh-my-fish/theme-bobthefish

# Powerline Fontをインストール
git clone https://github.com/powerline/fonts.git
./fonts/install.sh
rm -rf ./fonts

# Nert Fontsのインストール
git clone https://github.com/ryanoasis/nerd-fonts.git
./nerd-fonts/install.sh
rm -rf ./nerd-fonts
