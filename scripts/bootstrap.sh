#!/usr/bin/env bash

set -e

echo "[+] Installing base packages…"
if command -v pacman >/dev/null; then
  sudo pacman -S --needed stow git fish kitty --noconfirm
fi

echo "[+] Stowing dotfiles…"
cd ~/.dotfiles

# Stow common packages
stow fish
stow kitty
stow git

# OS/host-specific
if grep -q 'EndeavourOS' /etc/os-release; then
  stow arch
fi

if [[ $(hostname) == "my-laptop" ]]; then
  stow laptop
fi

echo "[✓] Done!"
