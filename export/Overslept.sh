#!/bin/sh
echo -ne '\033c\033]0;Overslept\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Overslept.x86_64" "$@"
