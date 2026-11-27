#!/bin/sh
printf '\033c\033]0;%s\a' FlappyBird
base_path="$(dirname "$(realpath "$0")")"
"$base_path/FlappyBird.x86_64" "$@"
