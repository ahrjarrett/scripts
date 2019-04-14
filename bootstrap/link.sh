#!/bin/sh

EXCLUDED_FILES="ssh_config|scripts|\.exclude|\.DS_Store|\.git$|\.gitignore$|.*.md$|.*.org$"

echo "EXCLUDED_FILES: $EXCLUDED_FILES"

echo "Creating symlinks..."
for file in $( ls -A $DOTFILES_LOCAL | grep -vE $EXCLUDED_FILES ) ; do
    echo "\n\nLinking: $DOTFILES_LOCAL/$file -> to the $HOME directory"
    ln -sv "$DOTFILES_LOCAL/$file" "$HOME"
  # fi
done
