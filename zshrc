##############################################################################################
#                                                                                            #
#                          This file is part of the global dotfiles.                         #
#                         Make host-specific changes in .zshrc.local!                        #
#  If that file does not exist, clone dotfiles_local and checkout the branch for this host.  #
#                                                                                            #
##############################################################################################

if [[ ! -v ZDOTDIR ]]; then
  export ZDOTDIR="$HOME"
fi

# Helpers
_cmd_exists() {
  (( $+commands[$1] ))
  return $?
}

_alias_to() {
  for a in $@[2,-1]; do
    if ! _cmd_exists "$a"; then
      alias "$a"="$1"
    fi
  done
}

# Cache an eval result for 1 day
_cache_eval() {
  # Based very loosely on the above compinit loader and the evalcache plugin
  setopt extendedglob local_options
  EVALCACHE_DIR="$HOME/.zsh/evalcache"
  mkdir -p "$EVALCACHE_DIR"
  local fname="$EVALCACHE_DIR/$1.zsh"
  local cfname="$fname.zwc"
  local fragment="$2"
  local globbed=($fname(N.mh-24))
  if (( $#globbed )); then
    source "$fname"
    { [[ ! -f "$cfname" || "$fname" -nt "$cfname" ]] && rm -f "$cfname" && zcompile "$fname" } &!
  else
    echo "$($=fragment)" > "$fname"
    source "$fname"
    { rm -f "$cfname" && zcompile "$fname" } &!
  fi
}

# Antibody (package management)
alias antibody-regen="antibody bundle < '$ZDOTDIR/.zsh_packages' > '$ZDOTDIR/.zsh_bundle.sh'"
if [[ -f "$ZDOTDIR/.zsh_bundle.sh" ]]; then
  source "$ZDOTDIR/.zsh_bundle.sh"
else
  echo "!! Using dynamically-loaded Antibody. This may be slower. Run 'antibody-regen' to statically generate."
  source <(antibody init)
  antibody bundle < "$ZDOTDIR/.zsh_packages"
fi

# System banner (if present)
if [[ -f "$HOME/.banner" ]]; then
  RELEASE=$(lsb_release -ds 2>/dev/null || printf "unknown")
  KERNEL=$(cat /proc/version_signature 2>/dev/null || cat /proc/version 2>/dev/null || printf "unknown")
  cat "$HOME/.banner" | sed -e "s/@RELEASE@/$RELEASE/" -e "s/@KERNEL@/$KERNEL/"
fi

# GPG2
export GPG_TTY=$(tty)
if _cmd_exists gpg2-agent; then
  GPG_AGENT="gpg2-agent"
  alias gpg="gpg2" # Sod you old distros
elif _cmd_exists gpg-agent; then
  GPG_AGENT="gpg-agent"
else
  echo "warn: unable to locate gpg(2)-agent -- is GPG installed?"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/tmp/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history auto_cd extended_glob share_history correct_all auto_list auto_menu always_to_end hist_ignore_space
unsetopt correct correct_all
bindkey -e

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

# Before Plugins setup
## NVM
export NVM_DIR="$HOME/.nvm"
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('nvim')

# Init completion using the cached completions
# Based loosely on https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2894219
_init_completions_custom() {
  # Skip completion if non-interactive
  if [[ -o interactive ]]; then
    autoload -Uz compinit
    setopt extendedglob local_options
    local zcd="$ZDOTDIR/.zcompdump"
    local zcdc="$zcd.zwc"
    local globbed=($zcd(N.mh-24))
    # Compile the completion dump to increase startup speed, if dump is newer or doesn't exist,
    # in the background as this is doesn't affect the current session
    if (( $#globbed )); then
          compinit -C -d "$zcd"
          { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
    else
          compinit -i -d "$zcd"
          { rm -f "$zcdc" && zcompile "$zcd" } &!
    fi
    zmodload -i zsh/complist
  fi
}

_init_completions_custom

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
if _cmd_exists brew; then
  export HOMEBREW_VERBOSE="true"
fi

# Krew for kubectl
if [[ -d "$HOME/.krew/bin" ]]; then
  export PATH="${HOME}/.krew/bin:${PATH}"
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
if _cmd_exists nvim; then
  export EDITOR="$(which nvim)"
  alias nv=nvim
  alias vim=nvim
  alias vi=nvim
elif _cmd_exists vim; then
  export EDITOR="$(which vim)"
  alias vi=vim
fi
if _cmd_exists go; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi
if [[ -d "/snap/bin" ]]; then export PATH="/snap/bin:$PATH"; fi
if [[ -d "$HOME/bin" ]]; then export PATH="$HOME/bin:$PATH"; fi
if [[ -d "/Applications/Visual Studio Code - Insiders.app" ]]; then export PATH="/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin:$PATH"; fi
if [[ -d "/Applications/Visual Studio Code.app" ]]; then export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"; fi

## Clang/LLVM
if _cmd_exists clang; then
  export CC="clang"
  export CXX="clang++"
  export HOMEBREW_CC="clang"
  export HOMEBREW_CXX="clang++"
fi

# Pyenv
if _cmd_exists pyenv; then
  _cache_eval pyenv-path "pyenv init --path"
  _cache_eval pyenv-init "pyenv init -"
  if _cmd_exists pyenv-virtualenv-init; then
    _cache_eval pyenv_virtualenv "pyenv virtualenv-init -"
  fi
fi

# Rbenv
if _cmd_exists rbenv; then
  _cache_eval rbenv "rbenv init -"
fi

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev/python

# Spark
if [ -d /usr/local/opt/apache-spark ]; then
  export SPARK_HOME="/usr/local/opt/apache-spark"
fi

# Pipx
if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Poetry
if [[ -d "$HOME/.poetry/bin" ]]; then
  export PATH="$HOME/.poetry/bin:$PATH"
fi

# Jabba (Java version management)
if [ -s "$HOME/.jabba/jabba.sh" ]; then
  source "$HOME/.jabba/jabba.sh"

  function __jabba_on_cd() {
    [[ -f "./.jabbarc" ]] && echo "\n☕️⚡️ Setting Jabba JDK from .jabbarc in $PWD: $(cat .jabbarc | tr -d "\n")" && jabba use
  }
  chpwd_functions=(${chpwd_functions[@]} "__jabba_on_cd")
fi

# Skip unnecessary bits for interactive shells
if [[ -o INTERACTIVE ]]; then

  # GitHub CLI
  if _cmd_exists gh; then
    _cache_eval gh "gh completion -s zsh"
    alias prc="gh pr create"
    alias prs="gh pr status"
    alias prv="gh pr view"
    alias prw="gh pr view --web"
    alias prsc="gh pr checks"
    alias prm="gh pr merge -d"
    function prd() {
      gh pr diff --patch $1 | delta
    }
  fi

  # bat, the better cat
  if _cmd_exists bat; then
    export BAT_THEME="TwoDark"
    alias cat=bat
  fi

  # thefuck
  if _cmd_exists thefuck; then
    eval "$(thefuck --alias)"
    eval "$(thefuck --alias arse)"
    eval "$(thefuck --alias shit)"
  fi

  # Aliases
  _alias_to kubectl k
  _alias_to kubectl kctl
  _alias_to kubens kns
  _alias_to kubectx kctx
  _alias_to toxiproxy-cli toxi

  _alias_to sudo _

  if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls="ls -h"
  else
    alias ls="ls --color=tty -h"
  fi

  # Filter out macOS, as that might be confused with the JDK apt tool
  if _cmd_exists apt && [[ "$OSTYPE" != "darwin"* ]]; then alias apt="sudo apt"; fi
  if _cmd_exists pacman; then alias pacman="sudo pacman"; fi
  if _cmd_exists zoxide; then eval "$(zoxide init zsh)"; fi
  if _cmd_exists exa; then
    alias ls="exa"
    alias la="exa -a"
    alias ll="exa -la"
  fi

  # Git aliases
  if _cmd_exists git; then
    alias gs="git status"
    alias gd="git diff"
    alias gp="git pull"
    alias gpp="git pull --prune"
    alias gc="git commit"
    alias gr="git rebase"
    alias gri="git rebase -i"
    alias gm="git merge"
    alias gco="git checkout"

    gppm() {
      git checkout $(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5) && git pull --prune
    }

    gpo() {
      git push -u origin $(git rev-parse --abbrev-ref HEAD)
    }

    if _cmd_exists delta; then
      alias gdd="git diff --no-ext-diff | delta"
    fi
  fi

  # iTerm tools
  send_notification() {
    echo -n "\e]9;$1\007"
  }

  # Key bindings
  bindkey ";5C" forward-word
  bindkey ";5D" backward-word
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char

  # Selecta (see https://github.com/garybernhardt/selecta/blob/master/EXAMPLES.md)
  if _cmd_exists selecta; then
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

  # To customize prompt, run `p10k configure` or edit ~/tmp/zsh/.p10k.zsh.
  [[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"

fi # End of Interactive block

# eval (http://superuser.com/a/230090)
# Invoke with 'zsh -is eval 'commandhere''
if [[ $1 == eval ]]
then
  "$@"
  set --
fi

# local profile
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
