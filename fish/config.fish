if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting

end

zoxide init fish | source
oh-my-posh init fish --config ~/.poshthemes/atomic.omp.json | source

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/arno/.ghcup/bin # ghcup-env
