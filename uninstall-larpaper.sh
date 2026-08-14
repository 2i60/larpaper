#!/usr/bin/env bash

set -euo pipefail

# This removes only files created by the release installer. It deliberately
# never resolves or removes the source checkout from which it may be run.
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
bin_home="${XDG_BIN_HOME:-$HOME/.local/bin}"
runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"

pkill -TERM -f "^bash $bin_home/larpaper( |$)" 2>/dev/null || true
pkill -TERM -f "^swayidle -w timeout [0-9]+ $bin_home/launch-larpaper( |$)" 2>/dev/null || true

rm -f -- \
  "$bin_home/larpaper" \
  "$bin_home/launch-larpaper" \
  "$bin_home/larpaper-idle" \
  "$bin_home/uninstall-larpaper" \
  "$data_home/applications/larpaper.desktop" \
  "$config_home/autostart/larpaper-idle.desktop" \
  "$runtime_dir/larpaper-idle.lock"

rm -f -- \
  "$config_home/larpaper/larpaper.conf" \
  "$config_home/larpaper/art.txt"
rmdir -- "$config_home/larpaper" 2>/dev/null || true

# Remove the legacy pre-config release directory if it is empty. User files
# are never recursively deleted.
rm -f -- "$data_home/larpaper/art.txt"
rmdir -- "$data_home/larpaper" 2>/dev/null || true

printf 'Larpaper release installation removed.\n'
