function tree --description 'eza tree with optional depth as first arg'
    # Usage:
    #   tree                -> full depth (no -L)
    #   tree 3              -> depth 3
    #   tree 0              -> full depth (treat 0 as "no limit")
    #   tree 2 src/ tests/  -> depth 2 for given paths
    #   tree src/           -> full depth for src/

    set -l args $argv
    set -l depthflag

    if test (count $args) -gt 0
        # If first arg is an integer, treat it as depth
        if string match -rq '^[1-9]+$' -- $args[1]
            set depthflag -L $args[1]
            set -e args[1] # remove the consumed depth argument
        end
    end

    # Default flags: --icons and grouping are nice; tweak to taste
    command eza --tree --icons --group-directories-first $depthflag $args
end
