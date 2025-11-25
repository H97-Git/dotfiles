if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_config theme choose "Dracula Official"
oh-my-posh init fish --config ~/omp.json | source
zoxide init fish | source
thefuck --alias | source

alias v nvim
alias ssh "kitty +kitten ssh"
alias ls "exa -1 --icons --group-directories-first -s Extension"
alias la "exa -la1 --icons --group-directories-first -s Extension"
alias hyprclients='hyprctl clients -j | jq -r ".[] | \"\(.address)  class=\(.class)  title=\(.title) floating=\(.floating)\""'
alias v nvim

alias vfish "cd ~/.config/fish;  v"
alias vnvim "cd ~/.config/nvim;  v"
alias vhypr "cd ~/.config/hypr;  v"
alias vkitty "cd ~/.config/kitty; v"

alias clc "history -1 | wl-copy"

abbr -a .. 'z ..'
abbr -a zz '..'
abbr -a q exit
abbr -a rd 'rm -rf'
abbr -a rmi 'rm -iv'
abbr -a py python
abbr -a py3 python3
abbr -a src 'source ~/.config/fish/config.fish'
# Git
abbr -a gst 'git status -sb'
abbr -a gco 'git checkout'
abbr -a gcm 'git commit -m'
abbr -a gl 'git pull --ff-only'
abbr -a gp 'git push'
abbr -a gaa 'git add -A'
# Docker (if installed)
abbr -a d docker
abbr -a dc 'docker compose'
abbr -a dcu 'docker compose up -d'
abbr -a dcd 'docker compose down'

if not contains $HOME/.local/bin $PATH
    set -x PATH $HOME/.local/bin $PATH
end

set -g BROWSER vivaldi
set -g EDITOR nvim

set -gx COLORTERM truecolor
set -gx VIRTUAL_ENV_DISABLE_PROMPT true
set -gx DOCKER_BUILDKIT 1
set -gx COMPOSE_DOCKER_CLI_BUILD 1
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_bind_mode insert

set -g theme_title_display_process yes
set -g theme_title_display_path yes
set -g theme_title_display_user yes
set -g theme_title_use_abbreviated_path yes

set -g theme_display_ruby yes
set -g theme_display_virtualenv yes
set -g theme_display_vagrant no
set -g theme_display_vi yes
set -g theme_display_k8s_context no # yes
set -g theme_display_user yes
set -g theme_display_hostname yes
set -g theme_show_exit_status yes
set -g theme_git_worktree_support no
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_master_branch yes
set -g theme_display_date yes
set -g theme_display_cmd_duration yes
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
