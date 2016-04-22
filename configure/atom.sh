#!/bin/sh
#
# Install Atom packages (from atom/packages) using apm
# Flags passed to this script will also be passed to apm
# Does NOT install Atom itself!
#

if !(hash apm 2>/dev/null); then
  echo "error: couldn't find apm."
  exit -1
fi

apm install "$@" --color --compatible --packages-file "$HOME/dotfiles/atom/pkgs"
