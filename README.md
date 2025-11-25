✅ 1. Install stow

On Arch / EndeavourOS:

sudo pacman -S stow

On Debian/Ubuntu:

sudo apt install stow

On macOS:

brew install stow

✅ 2. Create your dotfiles folder + init Git repo

Convention: use ~/.dotfiles (but many people also use ~/dotfiles).

mkdir -p ~/.dotfiles
cd ~/.dotfiles
git init
git remote add origin <git@github.com>:YOURUSER/dotfiles.git

(We’ll push everything later.)

✅ 3. Create the folder structure

Stow works by creating symlinks from a directory of “packages” into your $HOME.

Each package is a folder containing files that will map into your home directory.

Example structure:
~/.dotfiles
├── fish/
│ └── .config/
│ └── fish/
│ ├── config.fish
│ └── functions/
│ └── ...
├── kitty/
│ └── .config/
│ └── kitty/
│ └── kitty.conf
├── git/
│ └── .gitconfig
├── hypr/
│ └── .config/
│ └── hypr/
│ ├── hyprland.conf
│ └── ...
├── scripts/ ← optional convenience scripts
│ └── bootstrap.sh
└── README.md

🧠 How Stow interprets this

If you run in ~/.dotfiles:

stow fish

Stow creates symlinks:

~/.config/fish -> ~/.dotfiles/fish/.config/fish/

Same for kitty, git, hypr etc.

✅ 4. Populate each package

Example: Move your existing configs into your dotfiles repo.

Fish
mkdir -p ~/.dotfiles/fish/.config
mv ~/.config/fish ~/.dotfiles/fish/.config/

Kitty
mkdir -p ~/.dotfiles/kitty/.config
mv ~/.config/kitty ~/.dotfiles/kitty/.config/

Git
mv ~/.gitconfig ~/.dotfiles/git/.gitconfig

Hyprland
mkdir -p ~/.dotfiles/hypr/.config
mv ~/.config/hypr ~/.dotfiles/hypr/.config/

⚠️ After moving, the apps will be broken until you stow.

✅ 5. Stow everything

From inside ~/.dotfiles:

cd ~/.dotfiles
stow fish
stow kitty
stow git
stow hypr

Or a one-liner:

stow \*/

That’s it — your configs are now symlinked.

⭐️ 6. Add platform-specific folders (optional)

Common arch:

~/.dotfiles
├── common/ ← shared files
├── arch/ ← only for your Arch/EndeavourOS machines
├── laptop/ ← host-specific

You would stow them selectively on each device:

stow common
stow arch # only on Arch
stow laptop # only on your laptop

🚀 7. Add a bootstrap script for new machines (optional but recommended)

Create:

~/.dotfiles/scripts/bootstrap.sh

Example:

# !/usr/bin/env bash

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

if [[$(hostname) == "my-laptop"]]; then
stow laptop
fi

echo "[✓] Done!"

Make executable:

chmod +x ~/.dotfiles/scripts/bootstrap.sh

🚀 8. Commit & push
cd ~/.dotfiles
git add .
git commit -m "Initial dotfiles setup"
git branch -M main
git push -u origin main

💻 9. Using your dotfiles repo on a new machine (e.g., your laptop)

1. Install Git & Stow

(Arch)

sudo pacman -S git stow

2. Clone repo
   git clone <git@github.com>:YOURUSER/dotfiles.git ~/.dotfiles

3. Stow configs
   cd ~/.dotfiles
   stow fish kitty git hypr

Or if you have a bootstrap script:

~/.dotfiles/scripts/bootstrap.sh

Your machine now has the exact same config.

🎉 You’re done

You now have:

✔ A clean Git repo
✔ Dedicated folders (“packages”) per config group
✔ Automatic symlinking into your home
✔ Optional host/OS separation
✔ Optional bootstrap script for fresh installs
