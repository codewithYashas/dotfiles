# Only run in login shells
if [[ -o login ]]; then

  # 1) Save very first inherited PATH
  if [[ -z "$_ORIGINAL_PATH" ]]; then
    export _ORIGINAL_PATH=$PATH 
  fi

  # 2) Reset $PATH to that seed on every new login shell
  export PATH=$_ORIGINAL_PATH

  # 3) Conditionally add tools

  # homebrew
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # pyenv
  if command -v pyenv &>/dev/null; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
  fi

  # direnv
  if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
  fi

  # added for LM Studio CLI (lms)
  if [[ -d "$HOME/.lmstudio/bin" ]]; then
    export PATH="$HOME/.lmstudio/bin:$PATH"
  fi

  # N) Remove duplicate entries in $PATH
  typeset -U path   # re-synthesise $PATH from the array $path

fi
