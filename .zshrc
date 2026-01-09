## lang
export LANG=ja_JP.UTF-8

## PROMPT
PROMPT="%n ($(arch)):%~"$'\n'"%# "

## Alias
alias nv="nvim"
alias ls="ls -al"
alias lg="lazygit"

## XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$HOME/.config"

## HOMEBREW
export PATH="/opt/homebrew/bin:$PATH"

## Go
gopath=$(go env GOPATH)
export PATH="$gopath/bin:$PATH"

## OpenCode
export EDITOR=nvim

## GitHub Copilot CLI
export COPILOT_MODEL="claude-sonnet-4.5"

## zsh plugins
if type brew &>/dev/null; then
  # zsh-completions
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  # zsh-autosuggestions
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  # zsh-syntax-highlighting
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  autoload -Uz compinit && compinit
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

## Starship（最後の行にしておくこと）
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"
