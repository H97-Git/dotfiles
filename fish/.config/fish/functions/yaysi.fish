function yaysi --wraps=yay\ -Slq\ \|\ fzf\ --multi\ --preview\ \'yay\ -Si\ \{1\}\'\ \|\ xargs\ -ro\ sudo\ yay\ -S --wraps=yay\ -Slq\ \|\ fzf\ --multi\ --preview\ \'yay\ -Si\ \{1\}\'\ \|\ xargs\ -ro\ yay\ -S --description alias\ yaysi=yay\ -Slq\ \|\ fzf\ --multi\ --preview\ \'yay\ -Si\ \{1\}\'\ \|\ xargs\ -ro\ yay\ -S
    yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S $argv
end
