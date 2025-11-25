function dotadd -d "Add a config directory to ~/.dotfiles using stow structure"
    if test (count $argv) -ne 1
        echo "Usage: dotadd <config-name>"
        return 1
    end

    set name $argv[1]
    set src_dir "$HOME/.config/$name"
    set dst_package "$HOME/.dotfiles/$name"
    set dst_root "$dst_package/.config" # only up to .config, NOT .config/$name

    # Check source exists
    if not test -d $src_dir
        echo "❌ Error: Source directory '$src_dir' does not exist."
        echo "    → Did you mistype the name? (e.g. 'bpytop' vs 'bytop')"
        return 1
    end

    # Check package folder doesn't already exist
    if test -e $dst_package
        echo "❌ Error: Package folder '$dst_package' already exists."
        echo "    → Aborting to avoid overwriting existing dotfiles."
        return 1
    end

    echo "➡️  Preparing to move:"
    echo "    Source:      $src_dir"
    echo "    Destination: $dst_root/(basename: $name)"
    echo "    Final path:  $dst_root/$name/"
    echo ""

    # Confirm action
    read -l -P "Proceed? (y/N) " resp
    if test "$resp" != y
        echo "Aborted."
        return 0
    end

    # Create destination structure (.config only)
    mkdir -p $dst_root

    # Move the config into .config/, which creates .config/$name
    mv $src_dir $dst_root

    echo "✅ Moved!"
    echo "Result:"
    echo "    $dst_root/$name/"
    echo ""
    echo "Now you can stow it with:"
    echo "    cd ~/.dotfiles && stow $name"
end
