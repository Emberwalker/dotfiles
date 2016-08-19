#!/bin/bash
#
# Tries to run the usual atom_pkg script, but silently hides any failure.
#

bash installers/atom_pkgs.sh 2>&1 >/dev/null || true
