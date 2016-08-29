#!/bin/bash
#
# Update the ABS tree, copy core/linux to a tmp dir, apply patches and produce packages
# Robert Tully <robert.tully@drakon.io>
#

# Exit on error
set -e

OUT_DIR="$PWD"
PATCHES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

check_missing() {
  hash $1 2>/dev/null || {
    echo "!! Missing tool: $1"
    echo "!! Unable to continue. Install the package containing $1."
    exit -1
  };
}

echo ">> Checking for tools..."
check_missing abs
check_missing makepkg
check_missing patch
check_missing updpkgsums

echo ">> Updating ABS tree in /var/abs/..."
sudo abs

echo ">> Creating working directory..."
WORKING_DIR="$(mktemp --tmpdir -d icarus_build_XXXXXX)"
echo "  >> Done; $WORKING_DIR"
cd "$WORKING_DIR"

echo ">> Loading core/linux from ABS tree..."
cp -Rv /var/abs/core/linux/* "$WORKING_DIR/"

echo ">> Preparing build environment..."
cp -v "$PATCHES_DIR/acs_override.patch" "$WORKING_DIR/"
patch -p1 -F 3 -i "$PATCHES_DIR/linux_pkgbuild.patch"

echo ">> Updating package signatures..."
updpkgsums

printf ">> Build environment ready. Build now? [Y/n]: "
read
if [[ "$REPLY" = "n" || "$REPLY" = "N" ]]; then
  echo "Exiting on user request; build env left at $WORKING_DIR"
  exit 0
fi

echo ">> Building linux-icarus, this may take a while..."
makepkg -s

echo ">> Build completed. Copying artifacts..."
cp -v $WORKING_DIR/linux-icarus*.tar.xz "$OUT_DIR/"

echo ">> Done!"
exit 0
