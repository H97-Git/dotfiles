if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source
fish_config theme choose "Dracula Official"
oh-my-posh init fish --config ~/catppuccin.omp.json | source

alias v nvim
alias vi nvim
alias vim nvim
alias q exit
alias rd "rm -rf"
alias .. "cd .."
alias zz ..
alias clc "history -1 | xclip -selection clipboard"
set -g BROWSER vivaldi-stable
set -g EDITOR nvim
alias ssh "kitty +kitten ssh"

alias rebootnow rebootEnos
function rebootEnos
    cd
    ./bootnext enos now
end

alias tree "exa --tree --icons"
alias ls "exa -1 --icons --group-directories-first"

set -gx COLORTERM truecolor
set -gx EDITOR nvim
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

set -g fish_tmux_config $HOME/.config/tmux.conf

thefuck --alias | source
