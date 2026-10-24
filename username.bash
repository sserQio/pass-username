#!/usr/bin/env bash
# pass username - Password Store Extension (https://www.passwordstore.org/)

VERSION="1.0"

copy_cmd() {
        if [[ $(uname) == Darwin ]]; then
                pbcopy
        elif [[ -n $WAYLAND_DISPLAY ]]; then
                wl-copy
        else
                xclip -selection clipboard
        fi
}

clip=0

case "$1" in
	-c|--clip) clip=1; shift ;;
esac

entry="$1"
[[ -z $entry || $entry == "--help" ]] && { echo "Usage: pass username [--clip,-c] pass-name" >&2; exit 1; }

[[ $2 == "-c" || $2 == "--clip" ]] && clip=1

user=$(pass show "$entry" | sed -n 's/^[Uu]sername: *//p' | head -n1)

# No entry provided
[[ -z $user ]] && { echo "No Username field in $entry" >&2; exit 1; }

# 
if [[ $clip -eq 1 ]]; then
        printf %s "$user" | copy_cmd
        echo "Copied $entry username to the clipboard. Will clear in 45 seconds."
        ( sleep 45; printf '' | copy_cmd ) &
else
        echo "$user"
fi
