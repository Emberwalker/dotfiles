# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=250
SAVEHIST=250
setopt appendhistory autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Linuxbrew
if [[ -d "$HOME/.linuxbrew/bin" ]]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
fi

# Standard-issue aliases
alias emacs="emacs -nw"
alias emcs="emacs -nw"
alias em="emacs -nw"
alias vi="vim"
alias _="sudo"
if hash apt 2>/dev/null; then alias apt="sudo apt"; fi
if hash firejail 2>/dev/null; then alias jail="firejail"; fi

# Sensible default env vars
export EDITOR=vim
if hash go 2>/dev/null; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi
if [[ -d "$HOME/bin" ]]; then export PATH="$HOME/bin:$PATH"; fi
## Jayatana (Unity global menu support for Java apps)
if [[ $(ps aux | grep unity-panel | wc -l) -gt 1 ]] && [[ -f "/usr/share/java/jayatanaag.jar" ]]; then
  export JAVA_TOOL_OPTIONS="-javaagent:/usr/share/java/jayatanaag.jar $JAVA_TOOL_OPTIONS"
fi
## Clang/LLVM
if hash clang 2>/dev/null; then
  export CC="clang"
  export CXX="clang++"
  export HOMEBREW_CC="clang"
  export HOMEBREW_CXX="clang++"
fi

# thefuck
if hash thefuck 2>/dev/null; then
  eval "$(thefuck --alias)"
  eval "$(thefuck --alias arse)"
  eval "$(thefuck --alias shit)"
fi

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev/python

# GPG2
if hash gpg2-agent 2> /dev/null; then
  GPG_AGENT="gpg2-agent"
  alias gpg="gpg2" # Sod you old distros
elif hash gpg-agent 2> /dev/null; then
  GPG_AGENT="gpg-agent"
else
  echo "warn: unable to locate gpg(2)-agent -- is GPG installed?"
fi

# Antigen (Plugins)
if hash brew 2>/dev/null && [[ -f "$(brew --prefix)/share/antigen.zsh" ]]; then
  #echo "...loading antigen..."
  source "$(brew --prefix)/share/antigen.zsh"
  antigen use oh-my-zsh
  antigen bundles < "$HOME/dotfiles/zsh/bundles"
  antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train
  antigen apply
fi

# Theme customisation
export BULLETTRAIN_PROMPT_CHAR="λ"
export BULLETTRAIN_PROMPT_SEPARATE_LINE=true

export BULLETTRAIN_GIT_PROMPT_CMD=\${\$(git_prompt_info)//\\//\ \ }
export BULLETTRAIN_GIT_COLORIZE_DIRTY=false
export BULLETTRAIN_GIT_ADDED=" %F{green}✚%F{black}"
export BULLETTRAIN_GIT_MODIFIED=" %F{red}⚡%F{black}"
export BULLETTRAIN_GIT_UNTRACKED=" %F{cyan}⛊%F{black}"

export BULLETTRAIN_EXEC_TIME_SHOW=true

# System banner (if present)
if [[ -f "$HOME/.banner" ]]; then
  cat "$HOME/.banner" | sed -e "s/@RELEASE@/$(lsb_release -ds)/" -e "s/@KERNEL@/$(cat /proc/version_signature)/"
fi
