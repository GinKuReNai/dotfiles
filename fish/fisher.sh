#!/bin/sh

# fishのパッケージマネージャ `fisher` のインストール
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# fishのテーマとして bobthefish を追加
fisher install oh-my-fish/theme-bobthefish
