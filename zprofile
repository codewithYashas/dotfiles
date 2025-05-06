# load brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# load pyenv

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# hook direnv
eval "$(direnv hook zsh)"