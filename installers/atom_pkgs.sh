#!/bin/bash
#
# Installs the Atom packages specified in ~/.atom/pkgs
# Options passed to this script will be passed to apm verbatim.
# This script does NOT install Atom itself; see 'atom_deb.sh' for that on Debian derivatives.
#

if ! hash apm 2>/dev/null; then
  echo "!! Couldn't find apm, the Atom Package Manager. Is Atom installed?"
  exit -1
fi

apm install "$@" --color --compatible --packages-file "$HOME/.atom/pkgs"
