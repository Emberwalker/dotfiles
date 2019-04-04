##############################################################################################
#                                                                                            #
#                          This file is part of the global dotfiles.                         #
#                         Make host-specific changes in .zshrc.local!                        #
#  If that file does not exist, clone dotfiles_local and checkout the branch for this host.  #
#                                                                                            #
##############################################################################################

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history auto_cd extended_glob share_history correct_all auto_list auto_menu always_to_end
bindkey -e

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

zstyle :compinstall filename "$HOME/.zshrc"

# Init completion using the cached completions
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist

# Linuxbrew
test -d "$HOME/.linuxbrew" && export LINUXBREW_ROOT="$HOME/.linuxbrew"
test -d "/home/linuxbrew/.linuxbrew" && export LINUXBREW_ROOT="/home/linuxbrew/.linuxbrew"

if [[ $LINUXBREW_ROOT ]]; then
  export PATH="$LINUXBREW_ROOT/bin:$PATH"
  export MANPATH="$LINUXBREW_ROOT/share/man:$MANPATH"
  export INFOPATH="$LINUXBREW_ROOT/share/info:$INFOPATH"

  # GOROOT
  if [[ -d "$LINUXBREW_ROOT/opt/go/libexec/bin" ]]; then
    export PATH="$LINUXBREW_ROOT/opt/go/libexec/bin:$PATH"
  fi
fi

# Homebrew/Linuxbrew
if hash brew 2>/dev/null; then
  export HOMEBREW_VERBOSE="true"
fi

# Cargo
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Rust src
if [[ -d "$HOME/src/rust" ]]; then
  export RUST_SRC_PATH="$HOME/src/rust/src"
fi

# Load Zsh completions
if [[ -d "$HOME/dotfiles/zsh_completions" ]]; then
  export fpath=($fpath "$HOME/dotfiles/zsh_completions")
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
if [[ -d "/Applications/Visual Studio Code.app" ]]; then export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"; fi
if [[ -d "/Applications/Visual Studio Code - Insiders.app" ]]; then export PATH="/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin:$PATH"; fi
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

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

# Jenv (Java virtualenv)
if hash jenv 2>/dev/null; then
  eval "$(jenv init -)"
fi

# Jabba (Java version management)
[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"

if hash bat 2>/dev/null; then
  export BAT_THEME="TwoDark"
  alias cat=bat
fi

# thefuck
if hash thefuck 2>/dev/null; then
  eval "$(thefuck --alias)"
  eval "$(thefuck --alias arse)"
  eval "$(thefuck --alias shit)"
fi

# Tower Git
if hash gittower 2>/dev/null && ! hash tower 2>/dev/null; then
  alias tower=gittower
fi

# Selecta (see https://github.com/garybernhardt/selecta/blob/master/EXAMPLES.md)
if hash selecta 2>/dev/null; then
  # By default, ^S freezes terminal output and ^Q resumes it. Disable that so
  # that those keys can be used for other things.
  unsetopt flowcontrol
  # Run Selecta in the current working directory, appending the selected path, if
  # any, to the current command, followed by a space.
  function insert-selecta-path-in-command-line() {
      local selected_path
      # Print a newline or we'll clobber the old prompt.
      echo
      # Find the path; abort if the user doesn't select anything.
      selected_path=$(find * -type f | selecta) || return
      # Append the selection to the current command buffer.
      eval 'LBUFFER="$LBUFFER$selected_path "'
      # Redraw the prompt since Selecta has drawn several new lines of text.
      zle reset-prompt
  }
  # Create the zle widget
  zle -N insert-selecta-path-in-command-line
  # Bind the key to the newly created widget
  bindkey "^S" "insert-selecta-path-in-command-line"
fi

# Pyenv
if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)"
  if hash pyenv-virtualenv-init 2>/dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# Pipenv
if hash pipenv 2>/dev/null; then
  eval "$(pipenv --completion)"
fi

# Rbenv
if hash rbenv 2>/dev/null; then
  eval "$(rbenv init -)"
fi

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev/python

# Spark
if [ -d /usr/local/opt/apache-spark ]; then
  export SPARK_HOME="/usr/local/opt/apache-spark"
fi

# GPG2
export GPG_TTY=$(tty)
if hash gpg2-agent 2> /dev/null; then
  GPG_AGENT="gpg2-agent"
  alias gpg="gpg2" # Sod you old distros
elif hash gpg-agent 2> /dev/null; then
  GPG_AGENT="gpg-agent"
else
  echo "warn: unable to locate gpg(2)-agent -- is GPG installed?"
fi

# Theme customisation
## Bullet Train
export BULLETTRAIN_PROMPT_CHAR="λ"
export BULLETTRAIN_PROMPT_SEPARATE_LINE=true
export BULLETTRAIN_GIT_PROMPT_CMD=\${\$(git_prompt_info)//\\//\ \ }
export BULLETTRAIN_GIT_COLORIZE_DIRTY=false
export BULLETTRAIN_GIT_ADDED=" %F{green}✚%F{black}"
export BULLETTRAIN_GIT_MODIFIED=" %F{red}⚡%F{black}"
export BULLETTRAIN_GIT_UNTRACKED=" %F{cyan}⛊%F{black}"
export BULLETTRAIN_EXEC_TIME_SHOW=true
## Powerlevel9k
POWERLEVEL9K_INSTALLATION_PATH="$ANTIGEN_BUNDLES/bhilburn/powerlevel9k"
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%K{white}%F{black} `date +%T` %f%k%F{white}%f "
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh os_icon dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time pyenv java_version time background_jobs status)
POWERLEVEL9K_OS_ICON_BACKGROUND="white"
POWERLEVEL9K_OS_ICON_FOREGROUND="blue"
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_JAVA_ICON="\ue256"
POWERLEVEL9K_VPN_ICON="\ufa81"
POWERLEVEL9K_SSH_ICON="\ufc7e"
POWERLEVEL9K_VCS_UNTRACKED_ICON="\uf128"
POWERLEVEL9K_VCS_UNSTAGED_ICON="\uf12a"
POWERLEVEL9K_VCS_STAGED_ICON="\uf44d"
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON="\uf63b"
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON="\uf63e"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\ufb26%f "
## Geometry
GEOMETRY_PROMPT_PLUGINS=(exec_time git +kube node virtualenv)
GEOMETRY_COLOR_PROMPT="white"
PROMPT_GEOMETRY_GIT_TIME=false
PROMPT_GEOMETRY_GIT_CONFLICTS=true
PROMPT_GEOMETRY_COLORIZE_ROOT=true

# Load antigen (plugin management)
#source "/usr/local/share/antigen/antigen.zsh"
export DEFAULT_USER="arkan"
#antigen use oh-my-zsh
#antigen bundles < "$HOME/.zsh_packages"
#antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train
#antigen theme agnoster
#antigen theme bhilburn/powerlevel9k powerlevel9k
#antigen apply

# Antibody (package management)
source <(antibody init)
antibody bundle < "$HOME/.zsh_packages"

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
if hash exa 2>/dev/null; then
  alias ls="exa"
  alias la="exa -a"
fi

# Git aliases
alias gs="git status"
alias gp="git pull"
alias gpp="git pull --prune"
alias gppm="git checkout master && git pull --prune"
alias gc="git commit"
alias gr="git rebase"
alias gri="git rebase -i"
alias gm="git merge"
alias gco="git checkout"

gpo() {
  git push -u origin $(git rev-parse --abbrev-ref HEAD)
}

# Key bindings
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

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

# eval (http://superuser.com/a/230090)
# Invoke with 'zsh -is eval 'commandhere''
if [[ $1 == eval ]]
then
  "$@"
  set --
fi
