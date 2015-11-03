# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=250
SAVEHIST=250
setopt appendhistory autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/arkan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# PS1
autoload -U colors && colors
export PROMPT="%{$fg_bold[red]%}%m :: %~ %{%(!.$fg[green].$fg_bold[red])%}>> %{$reset_color%b%}"
export RPROMPT=""

alias emacs="emacs -nw"
alias emcs="emacs -nw"
alias em="emacs -nw"
alias vi="vim"

alias _="sudo"

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

