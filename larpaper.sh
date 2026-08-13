#!/usr/bin/env bash

set -u

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_art_file="$script_dir/art.txt"
installed_art_file="${XDG_DATA_HOME:-$HOME/.local/share}/larpaper/art.txt"

if [[ -r "$repo_art_file" ]]; then
  art_file="$repo_art_file"
else
  art_file="$installed_art_file"
fi
showoff=0
[[ "${1:-}" == "--showoff" ]] && showoff=1

if [[ ! -r "$art_file" ]]; then
  printf 'Larpaper artwork is missing: %s\n' "$art_file" >&2
  exit 1
fi

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

(
  effect_pid=""
  trap '[[ -n "$effect_pid" ]] && kill "$effect_pid" 2>/dev/null; exit 0' TERM INT HUP
  while :; do
    printf '\033[2J\033[H'
    tte --input-file "$art_file" \
      --random-effect \
      --frame-rate 120 \
      --canvas-width 0 \
      --canvas-height 0 \
      --anchor-canvas c \
      --anchor-text c \
      --no-eol \
      --no-restore-cursor </dev/null &
    effect_pid=$!
    wait "$effect_pid" || true
    effect_pid=""
    sleep 1
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
