#!/bin/sh

# fishのパッケージマネージャ `fisher` のインストール
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# 文字化けするので Powerline Fontをインストール
fisher install oh-my-fish/theme-bobthefish
git clone https://github.com/powerline/fonts.git
./fonts/install.sh
rm -rf ./fonts

