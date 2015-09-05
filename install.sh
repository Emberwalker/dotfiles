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
  git clone https://github.com/Emberwalker/dotvim.git ~/.vim > /dev/null 2>&1
  echo "    >> Copying vimrc shim..."
  cp -v skeletons/vimrc "$HOME/.vimrc"
else
  echo "    >> Can't find a copy of git, skipping .vim prep."
fi

echo ">> Done!"
