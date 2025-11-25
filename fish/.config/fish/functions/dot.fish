function dot
    switch $argv
        case ''
            cd ~/.config/
            nvim ~/.config/
        case '*'
            cd ~/.config/
            cd $argv
            nvim ~/.config/$argv
    end
end
