# Neovim configuration

どこでも NeoVim 環境を立ち上げることを目的に、Docker を用いた起動方法を実装しています。

## 手順

1. Docker コンテナをビルドする

```sh
docker build -t mynvim .
```

2. mynvim を `~/.local/bin/` にコピーする

```sh
cp mynvim ~/.local/bin/
```
