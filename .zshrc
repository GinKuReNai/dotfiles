## lang
export LANG=ja_JP.UTF-8

## PROMPT
PROMPT="%n ($(arch)):%~"$'\n'"%# "

## XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$HOME/.config"

## HOMEBREW
export PATH="/opt/homebrew/bin:$PATH"

## Go
gopath=$(go env GOPATH)
export PATH="$gopath/bin:$PATH"

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

## Starship（最後の行にしておくこと）
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"
