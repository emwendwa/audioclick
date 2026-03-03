#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <folder_path> [output_zip]" >&2
  exit 1
fi

folder_path="$1"
if [[ ! -d "$folder_path" ]]; then
  echo "Error: '$folder_path' is not a directory." >&2
  exit 1
fi

folder_name="$(basename "$folder_path")"
default_output="${folder_name}.zip"
output_zip="${2:-$default_output}"

(
  cd "$folder_path"
  shopt -s nullglob
  files=()
  for item in *; do
    [[ -f "$item" ]] && files+=("$item")
  done

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "Error: no files found directly in '$folder_path'." >&2
    exit 1
  fi

  zip -q "../$output_zip" "${files[@]}"
)

echo "Created: $output_zip"
