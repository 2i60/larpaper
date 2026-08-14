#!/usr/bin/env bash

set -u

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
launcher="$script_dir/launch-larpaper.sh"
larpaper="$script_dir/larpaper.sh"
[[ -x "$launcher" ]] || launcher="$script_dir/launch-larpaper"
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
readonly lock_file="${XDG_RUNTIME_DIR:-/tmp}/larpaper-idle.lock"

exec 9>"$lock_file"
flock -n 9 || exit 0

exec swayidle -w \
  timeout "$IDLE_TIMEOUT" "$launcher" \
  resume "pkill -TERM -f '^bash $larpaper( |$)' 2>/dev/null || true"
