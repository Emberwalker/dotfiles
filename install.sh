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

if [[ -d "$HOME/.virtualenvs" ]]; then
  rm -rf "$HOME/.virtualenvs.old" 2> /dev/null
  mv -v "$HOME/.virtualenvs" "$HOME/.virtualenvs.old"
fi

# Install skeletons
echo ">> Installing skeletons..."
cp -v skeletons/vimrc "$HOME/.vimrc"
cp -v skeletons/zshrc "$HOME/.zshrc"
mkdir "$HOME/.virtualenvs"
ln -v -s "`pwd`/virtualenvs/postactivate" "$HOME/.virtualenvs/postactivate"

# Run updaters
echo ">> Updating where possible..."

which vim > /dev/null 2>&1
if [[ $? == 0 ]]; then
  echo "    >> \`vim +PluginUpdate +qall\`"
  vim +PluginUpdate +qall
fi

echo ">> Done!"
