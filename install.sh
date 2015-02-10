#!/bin/sh
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
cp -v skeletons/vimrc "$HOME/.vimrc"
cp -v skeletons/zshrc "$HOME/.zshrc"
cp -v skeletons/tmuxrc "$HOME/.tmux.conf"
cp -v skeletons/tmux-powerlinerc "$HOME/.tmux-powerlinerc"
mkdir "$HOME/.virtualenvs"
ln -v -s "`pwd`/virtualenvs/postactivate" "$HOME/.virtualenvs/postactivate"

# Run updaters
echo ">> Updating where possible..."

which git > /dev/null 2>&1
if [[ $? == 0 ]]; then
  echo "    >> \`git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim\`"
  mkdir -p "$HOME/.vim/bundle" > /dev/null 2>&1
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null 2>&1
fi

which vim > /dev/null 2>&1
if [[ $? == 0 ]]; then
  echo "    >> \`vim +PluginUpdate +qall\`"
  vim +PluginUpdate +qall
fi

echo ">> Done!"
