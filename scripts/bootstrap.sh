#!/usr/bin/env bash

set -e

echo "[+] Installing required packages…"
if command -v pacman >/dev/null; then
  sudo pacman -S --needed stow git --noconfirm
fi

echo "[+] Installing base packages…"
if command -v pacman >/dev/null; then
  sudo pacman -S --needed fish fisher omf kitty vivaldi waybar rofi wl-clipboard thunar --noconfirm
fi

echo "[+] Installing development environment packages…"
if command -v pacman >/dev/null; then
  sudo pacman -S --needed nvim nodejs npm python3 --noconfirm
fi

echo "[+] Installing CLI utils packages…"
if command -v pacman >/dev/null; then
  sudo pacman -S --needed lazygit zoxide exa bat clipse neofetch fd bpytop --noconfirm
fi

echo "[+] Installing utils packages…"
if command -v pacman >/dev/null; then
  sudo pacman -S --needed slurp grim satty appimagelauncher --noconfirm
fi

echo "[+] Stowing dotfiles…"
cd ~/.dotfiles

# Stow common packages
stow fish
stow kitty
stow bpytop
stow hypr
stow nvim
stow rofi
stow superfile
stow waybar

# OS/host-specific
if grep -q 'EndeavourOS' /etc/os-release; then
  stow arch
fi

if [[ $(hostname) == "my-laptop" ]]; then
  stow laptop
fi

echo "[✓] Done!"
