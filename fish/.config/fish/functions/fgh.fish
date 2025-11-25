function fgh
    switch $argv
        case ''
            history | fzf | wl-copy
        case '*'
            history | grep $argv | fzf | wl-copy
    end
end
