#!/usr/bin/env bash

EXCLUDED_FILES="ssh_config|scripts|\.exclude|\.DS_Store|\.git$|\.gitignore$|.gitconfig$|.*.md$|.*.org$"

echo "EXCLUDED_FILES: $EXCLUDED_FILES"

# do the .gitconfig file separately (in general, start moving things to ~/.config)
ln -sv "$DOTFILES_LOCAL/.gitconfig" "$HOME/.config/git/config"
ln -sv "$DOTFILES_LOCAL/Hyper" "$HOME/.config"

echo "Creating symlinks..."
for file in $( ls -A $DOTFILES_LOCAL | grep -vE $EXCLUDED_FILES ) ; do
    echo "\n\nLinking: $DOTFILES_LOCAL/$file -> to the $HOME directory"
    ln -sv "$DOTFILES_LOCAL/$file" "$HOME"
  # fi
done
