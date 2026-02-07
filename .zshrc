case "$(uname)" in
  Darwin) OS='Mac' ;;
  Linux)  OS='Linux' ;;
esac

# ==========================================================
# 共通設定（OS問わず使うもの）
# ==========================================================
export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim
export COPILOT_MODEL="claude-sonnet-4.5"

# Claude Code
export PATH="$HOME/.local/bin:$PATH"

# Neovim
# AppImage で install した場合のPATH
# https://neovim.io/doc/install/
export PATH="$PATH:/opt/nvim/"

# Alias
alias nv="nvim"
alias lg="lazygit"

# Zsh基本設定 (履歴・補完)
setopt histignorealldups sharehistory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'

# ==========================================================
# OS別設定（パスやプラグイン）
# ==========================================================
if [ "$OS" = 'Mac' ]; then
    # --- macOS専用 ---
    alias ls="ls -G -al"
    export PATH="/opt/homebrew/bin:$PATH"
    
    # Homebrew系プラグインの読み込み
    if [ -d "$(brew --prefix)" ]; then
        FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
        source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
    fi
    # プロンプトにアーキテクチャを表示
    PROMPT="%n ($(arch)):%~"$'\n'"%# "

elif [ "$OS" = 'Linux' ]; then
    # --- Linux (Ubuntu)専用 ---
    alias ls="ls --color=auto -al"
    
    # aptで入れたプラグインの読み込み
    [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    PROMPT="%n:%~ %# "
fi

# ==========================================================
# 共通ツール (Go, Pyenv, Starship)
# ==========================================================
# Go
if command -v go &>/dev/null; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init - zsh)"
fi

# Starship (最後に実行)
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
    eval "$(starship init zsh)"
fi
