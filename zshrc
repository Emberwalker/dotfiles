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
export PROMPT="%{$fg_bold[red]%}%m ⤏  %~ %{%(!.$fg[green].$fg_bold[red])%}>> %{$reset_color%b%}"
export RPROMPT=""

alias emacs="emacs -nw"
alias emcs="emacs -nw"
alias em="emacs -nw"
alias vi="vim"

alias _="sudo"

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev/python
