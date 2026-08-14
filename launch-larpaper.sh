#!/usr/bin/env bash

set -euo pipefail

case "${1:-}" in
  ""|--showoff) ;;
  *) printf 'Usage: %s [--showoff]\n' "${0##*/}" >&2; exit 2 ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
larpaper="$script_dir/larpaper.sh"
[[ -x "$larpaper" ]] || larpaper="$script_dir/larpaper"
repo_config="$script_dir/larpaper.conf"
installed_config="${XDG_CONFIG_HOME:-$HOME/.config}/larpaper/larpaper.conf"
[[ -r "$repo_config" ]] && config_file="$repo_config" || config_file="$installed_config"

if [[ ! -r "$config_file" ]]; then
  printf 'Larpaper config is missing: %s\n' "$config_file" >&2
  exit 1
fi

# shellcheck source=larpaper.conf
source "$config_file"

if pgrep -f "^bash $larpaper( |$)" >/dev/null; then
  exit 0
fi

exec kitty \
  --class larpaper \
  --title 'Larpaper' \
  --start-as fullscreen \
  --override font_size="$FONT_SIZE" \
  --override window_padding_width=0 \
  --override background="$BACKGROUND" \
  --override background_opacity="$BACKGROUND_OPACITY" \
  --override dynamic_background_opacity=no \
  --override hide_window_decorations=yes \
  --override tab_bar_style=hidden \
  --override confirm_os_window_close=0 \
  --override mouse_hide_wait="$MOUSE_HIDE_WAIT" \
  --override cursor_shape="$CURSOR_SHAPE" \
  "$larpaper" "${1:-}"
