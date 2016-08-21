##############################################################################################
#                                                                                            #
#                          This file is part of the global dotfiles.                         #
#                         Make host-specific changes in .zshrc.local!                        #
#  If that file does not exist, clone dotfiles_local and checkout the branch for this host.  #
#                                                                                            #
##############################################################################################

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
if [[ -d "$HOME/.linuxbrew" ]]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# Sensible default env vars
if hash vim 2>/dev/null; then
  export EDITOR="$(which vim)"
fi
if hash nvim 2>/dev/null; then
  export EDITOR="$(which nvim)"
fi
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

# Load antigen (plugin management)
fpath=("$HOME/.antigen.zsh" $fpath)
source "$HOME/.antigen.zsh"
export DEFAULT_USER="arkan"
antigen use oh-my-zsh
antigen bundles < "$HOME/.zsh_packages"
#antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train
antigen theme agnoster
antigen apply

# Standard-issue aliases
alias emacs="emacs -nw"
alias emcs="emacs -nw"
alias em="emacs -nw"
alias _="sudo"
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls="ls -h"
else
  alias ls="ls --color=tty -h"
fi
if hash vim 2>/dev/null; then alias vi="vim"; fi
if hash nvim 2>/dev/null; then
  alias nv="nvim"
  alias vi="nvim"
  alias vim="nvim"
fi
if hash apt 2>/dev/null; then alias apt="sudo apt"; fi
if hash pacman 2>/dev/null; then alias pacman="sudo pacman"; fi
if hash firejail 2>/dev/null; then alias jail="firejail"; fi

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
  RELEASE=$(lsb_release -ds 2>/dev/null || printf "unknown")
  KERNEL=$(cat /proc/version_signature 2>/dev/null || cat /proc/version 2>/dev/null || printf "unknown")
  cat "$HOME/.banner" | sed -e "s/@RELEASE@/$RELEASE/" -e "s/@KERNEL@/$KERNEL/"
fi

# local profile
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
