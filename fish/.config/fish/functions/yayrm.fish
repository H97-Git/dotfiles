function yayrm --description 'Remove explicitly installed packages (not auto-deps)' \
    --wraps='yay -Qeq | fzf --multi --preview "yay -Qi {1}" | xargs -ro yay -Rns'
    set -l cmd yay -Rns
    if set -q argv[1]
        set cmd yay $argv
    end

    yay -Qeq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro $cmd
end
