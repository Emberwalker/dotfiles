#!/bin/bash
#
# Simple install/update script for Atom on Ubuntu/Debian
#

# Exit on error
set -e

# Dependencies
## gdebi
if ! hash gdebi 2>/dev/null; then
  echo 'error: gdebi is not available; install with `apt install gdebi` then rerun this script.'
  exit -1
fi

## cURL
if ! hash curl 2>/dev/null; then
  echo 'error: curl is not available; install with `apt install curl` then rerun this script.'
  exit -1
fi

## jq
if ! hash jq 2>/dev/null; then
  echo 'error: jq is not available; install with `apt install jq` then rerun this script.'
  exit -1
fi


# Is Atom installed as a deb?
if apt-cache show atom 2>&1 >/dev/null; then
  ATOM_INSTALLED=1
  ATOM_VERSION="$(dpkg-query --showformat='${Version}' --show atom)"
else
  ATOM_INSTALLED=0
fi

echo ">> Fetching latest Atom release information..."
ATOM_LATEST_JSON="$(curl -s https://api.github.com/repos/atom/atom/releases/latest)"
ATOM_LATEST=$(echo "$ATOM_LATEST_JSON" | jq -r '.name')

if [[ $ATOM_INSTALLED == 1 ]]; then echo "  >> Current: $ATOM_VERSION"; fi
echo "  >> Latest: $ATOM_LATEST"

if [[ "$ATOM_VERSION" = "$ATOM_LATEST" && "$1" != "--force" ]]; then
  echo "  >> Up to date. Nothing to be done."
  exit 0
fi

echo ">> Fetching latest Atom debian package..."
DOWNLOAD_URL="$(echo "$ATOM_LATEST_JSON" | jq -r '.assets[] | if (.name == "atom-amd64.deb") then .browser_download_url else empty end')"
TMP_FILE="$(mktemp /tmp/atom.XXXXXX.deb)"
echo "  >> $DOWNLOAD_URL -> $TMP_FILE"
curl -L# "$DOWNLOAD_URL" -o "$TMP_FILE"

echo ">> Handing off to gdebi..."
sudo gdebi "$TMP_FILE"

echo ">> Cleaning up..."
rm -v "$TMP_FILE"
