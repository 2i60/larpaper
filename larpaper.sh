#!/usr/bin/env bash

set -u

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_config="$script_dir/larpaper.conf"
installed_config="${XDG_CONFIG_HOME:-$HOME/.config}/larpaper/larpaper.conf"
[[ -r "$repo_config" ]] && config_file="$repo_config" || config_file="$installed_config"

if [[ ! -r "$config_file" ]]; then
  printf 'Larpaper config is missing: %s\n' "$config_file" >&2
  exit 1
fi

# shellcheck source=larpaper.conf
source "$config_file"

art_file="$(dirname -- "$config_file")/art.txt"
if [[ ! -r "$art_file" ]]; then
  printf 'Larpaper artwork is missing: %s\n' "$art_file" >&2
  exit 1
fi
showoff=0
[[ "${1:-}" == "--showoff" ]] && showoff=1

wait_for_terminal_size() {
  local previous current stable=0 attempts=0

  sleep 0.1
  previous="$(stty size 2>/dev/null || true)"
  [[ -n "$previous" ]] || return 0
  while (( attempts < 18 && stable < 8 )); do
    sleep 0.05
    current="$(stty size 2>/dev/null || true)"

    if [[ -n "$current" && "$current" == "$previous" ]]; then
      (( stable += 1 ))
    else
      stable=0
      previous="$current"
    fi
    (( attempts += 1 ))
  done
}

cleanup() {
  [[ -n "${activity_pid:-}" ]] && kill "$activity_pid" 2>/dev/null || true
  [[ -n "${renderer_pid:-}" ]] && kill "$renderer_pid" 2>/dev/null || true
  printf '\033[?25h\033[0m\033[2J\033[H'
  stty echo 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 0' INT TERM HUP

printf '\033[?25l\033[2J\033[H'
stty -echo 2>/dev/null || true
wait_for_terminal_size

(
  effect_pid=""
  trap '[[ -n "$effect_pid" ]] && kill "$effect_pid" 2>/dev/null; exit 0' TERM INT HUP
  while :; do
    printf '\033[2J\033[H'
    tte --input-file "$art_file" \
      "${TTE_EFFECT_ARGS[@]}" \
      --frame-rate "$FRAME_RATE" \
      --canvas-width "$CANVAS_WIDTH" \
      --canvas-height "$CANVAS_HEIGHT" \
      --anchor-canvas "$ANCHOR_CANVAS" \
      --anchor-text "$ANCHOR_TEXT" \
      --no-eol \
      --no-restore-cursor </dev/null &
    effect_pid=$!
    wait "$effect_pid" || true
    effect_pid=""
    sleep "$EFFECT_PAUSE"
  done
) &
renderer_pid=$!

if (( showoff )); then
  wait "$renderer_pid"
else
  swayidle -w timeout 1 true resume "kill -TERM $$" &
  activity_pid=$!
  IFS= read -rsn 1 || true
fi
