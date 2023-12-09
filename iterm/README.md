# Iterm2 & fish configuration

Mac で使用している Iterm2 とシェル環境である fish の環境をインストールできるようにします。

## 手順

1. Brewfile で Iterm2, fish を含むパッケージをインストール

2. デフォルトの shell を fish にする

```sh
sudo vi /etc/shells
```

その後、最後尾に下記を追加

```
/usr/local/bin/fish
```

3. fisher.sh を実行する

4. Iterm2 の設定で com.googlecode.iterm2.plist をインポートする

fisher.sh でインストールした Powerline もデフォルトのフォントとして設定される。
