#!/usr/bin/env bash

set -u

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
launcher="$script_dir/launch-larpaper.sh"
larpaper="$script_dir/larpaper.sh"
[[ -x "$launcher" ]] || launcher="$script_dir/launch-larpaper"
[[ -x "$larpaper" ]] || larpaper="$script_dir/larpaper"
readonly lock_file="${XDG_RUNTIME_DIR:-/tmp}/larpaper-idle.lock"

exec 9>"$lock_file"
flock -n 9 || exit 0

exec swayidle -w \
  timeout 300 "$launcher" \
  resume "pkill -TERM -f '^bash $larpaper( |$)' 2>/dev/null || true"
