#!/usr/bin/env bash

set -euo pipefail

assume_yes=0
[[ "${1:-}" == "--yes" ]] && assume_yes=1

# This removes only files created by the release installer. It deliberately
# never resolves or removes the source checkout from which it may be run.
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
bin_home="${XDG_BIN_HOME:-$HOME/.local/bin}"
runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"

if [[ -r "$config_home/larpaper/art.txt" ]]; then
  artwork="$(cat "$config_home/larpaper/art.txt")"
else
  artwork='L A R P A P E R'
fi

printf '\nLarpaper release uninstaller\n\n'
printf 'This will remove the release-installed commands, autostart entry,\n'
printf 'application entries, configuration, and artwork.\n'
printf 'Kitty, tte, swayidle, and source checkouts will not be removed.\n\n'
printf 'Continue? [y/N] '
if (( assume_yes )); then
  printf 'yes\n'
else
  IFS= read -r answer
  [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]] || {
    printf 'Uninstall cancelled.\n'
    exit 0
  }
fi

printf '\nStopping Larpaper processes...\n'

pkill -TERM -f "^bash $bin_home/larpaper( |$)" 2>/dev/null || true
pkill -TERM -f "^swayidle -w timeout [0-9]+ $bin_home/launch-larpaper( |$)" 2>/dev/null || true

printf 'Removing release-installed files...\n'
rm -f -- \
  "$bin_home/larpaper" \
  "$bin_home/launch-larpaper" \
  "$bin_home/larpaper-idle" \
  "$bin_home/uninstall-larpaper" \
  "$data_home/applications/larpaper.desktop" \
  "$data_home/applications/uninstall-larpaper.desktop" \
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

printf '\nLarpaper release installation removed.\n\n%s\n' "$artwork"

if [[ -t 0 && $assume_yes -eq 0 ]]; then
  printf '\nPress Enter to close.'
  IFS= read -r _ || true
fi
