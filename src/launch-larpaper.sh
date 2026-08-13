#!/usr/bin/env bash

set -euo pipefail

case "${1:-}" in
  ""|--showoff) ;;
  *) printf 'Usage: %s [--showoff]\n' "${0##*/}" >&2; exit 2 ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
larpaper="$script_dir/larpaper.sh"
[[ -x "$larpaper" ]] || larpaper="$script_dir/larpaper"

if pgrep -f "^bash $larpaper( |$)" >/dev/null; then
  exit 0
fi

exec kitty \
  --class larpaper \
  --title 'Larpaper' \
  --start-as fullscreen \
  --override font_size=18 \
  --override window_padding_width=0 \
  --override background='#000000' \
  --override background_opacity=1.0 \
  --override dynamic_background_opacity=no \
  --override hide_window_decorations=yes \
  --override tab_bar_style=hidden \
  --override confirm_os_window_close=0 \
  --override mouse_hide_wait=0.01 \
  --override cursor_shape=block \
  "$larpaper" "${1:-}"
