## Alacritty

### True Color 設定

1. `brew install ncurses`
2. `/opt/homebrew/Cellar/ncurses/<version>/bin/infocmp tmux-256color > ~/tmux-256color.info`
3. `tic -xe tmux-256color tmux-256color.info`
4. `infocmp tmux-256color | head`
