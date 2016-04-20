#!/bin/bash
#
# Install script for dotfiles
#
# Copies skeletons to appropriate places to import the repo dotfiles.
#

if [[ "`pwd`" != "$HOME/dotfiles" ]]; then
  echo "Not in ~/dotfiles! Did you clone to ~/dotfiles, or ran the script from another dir?"
  exit -1
fi

# Dependencies
## Ruby (for brew)
if hash ruby 2>/dev/null; then
  echo ">> Found Ruby interpreter."
  HAS_RUBY=1
else
  echo "!! >> Couldn't find a Ruby interpreter."
  HAS_RUBY=0
fi

if hash curl 2>/dev/null; then
  echo ">> Found cURL."
  HAS_CURL=1
else
  echo "!! >> Couldn't find cURL."
  HAS_CURL=0
fi

## home/linuxbrew
if ([ $HAS_RUBY == 1 ] && [ $HAS_CURL == 1 ]); then
  # In case PATH is missing bits
  if [[ -d "$HOME/.linuxbrew" ]]; then
    export PATH="$HOME/.linuxbrew/bin:$PATH"
  fi
  if hash brew 2>/dev/null; then
    echo ">> Found Homebrew/Linuxbrew."
    HOMEBREW=1
  else
    if [[ "$OSTYPE" == "linux"* ]]; then
      echo ">> Installing Linuxbrew..."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"
      export PATH="$HOME/.linuxbrew/bin:$PATH"
      HOMEBREW=1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      echo ">> Installing Homebrew..."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      export PATH="/usr/local/bin:$PATH"
      HOMEBREW=1
    else
      echo "!! >> Unknown OS type: $OSTYPE - unable to acquire Homebrew."
      HOMEBREW=0
    fi
  fi
fi

# Homebrew installations
if [[ $HOMEBREW == 1 ]]; then
  echo ">> Installing missing Homebrew packages..."
  if !(hash git 2>/dev/null); then
    echo "Installing git..."
    brew install git
  fi
  if !([[ -f "$(brew --prefix)/share/antigen.zsh" ]]); then
    echo "    >> Installing Antigen..."
    brew install antigen
  fi
  if !(hash thefuck 2>/dev/null); then
    echo "    >> Installing thefuck..."
    brew install thefuck
  fi
fi

# Archive old crap
echo ">> Archiving old scripts (if exists)..."
if [[ -f "$HOME/.zshrc" ]]; then
  mv -v "$HOME/.zshrc" "$HOME/.zshrc.old"
fi

if [[ -f "$HOME/.vimrc" ]]; then
  mv -v "$HOME/.vimrc" "$HOME/.vimrc.old"
fi

if [[ -f "$HOME/.tmux.conf" ]]; then
  mv -v "$HOME/.tmux.conf" "$HOME/.tmux.conf.old"
fi

if [[ -f "$HOME/.tmux-powerlinerc" ]]; then
  mv -v "$HOME/.tmux-powerlinerc" "$HOME/.tmux-powerlinerc.old"
fi

if [[ -d "$HOME/.virtualenvs" ]]; then
  rm -rf "$HOME/.virtualenvs.old" 2> /dev/null
  mv -v "$HOME/.virtualenvs" "$HOME/.virtualenvs.old"
fi

# Install skeletons
echo ">> Installing skeletons..."
cp -v skeletons/zshrc "$HOME/.zshrc"
cp -v skeletons/tmuxrc "$HOME/.tmux.conf"
cp -v skeletons/tmux-powerlinerc "$HOME/.tmux-powerlinerc"
mkdir "$HOME/.virtualenvs"
ln -v -s "`pwd`/virtualenvs/postactivate" "$HOME/.virtualenvs/postactivate"

# Vimvimvim...
echo ">> Trying Vim template..."
which git > /dev/null 2>&1
if [[ $? == 0 ]]; then
  echo "    >> Archiving old .vim..."
  if [[ -d "$HOME/.vim" ]]; then
    rm -rf "$HOME/.vim.old" 2> /dev/null
    mv -v "$HOME/.vim" "$HOME/.vim.old"
  fi
  echo "    >> \`git clone\`..."
  git clone --recursive https://github.com/Emberwalker/dotvim.git ~/.vim
  echo "    >> Copying vimrc shim..."
  cp -v skeletons/vimrc "$HOME/.vimrc"
else
  echo "    >> Can't find a copy of git, skipping .vim prep."
fi

# GPG2
# First check if we need 'gpg2' prefix or not.
if hash gpg2-agent 2>/dev/null; then
  GPG_AGENT="gpg2-agent"
  GPG2_PREFIX=true
else
  GPG_AGENT="gpg-agent"
  GPG2_PREFIX=false
fi

# Setup dirs and link configs
mkdir "$HOME/.gnupg" 2>/dev/null
ln -s "$HOME/dotfiles/gpg.conf" "$HOME/.gnupg/gpg.conf" 2>/dev/null
ln -s "$HOME/dotfiles/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf" 2>/dev/null

echo ">> Done!"
