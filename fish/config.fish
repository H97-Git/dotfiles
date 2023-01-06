if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source
oh-my-posh init fish --config ~/.mytheme.omp.json | source

source "$HOME/.config/fish/conf.d/catppuccin.fish"

alias v nvim
alias vi nvim
alias vim nvim
# alias emacs "emacsclient -c -a 'emacs'"
alias q exit
alias rd "rm -rf"
alias .. "cd .."
alias zz ..
alias clc "history -1 | xclip -selection clipboard"
set -g BROWSER vivaldi-stable
set -g EDITOR nvim
