#!/usr/bin/env bash

EXCLUDED_FILES="ssh_config|scripts|\.exclude|\.DS_Store|\.git$|\.gitignore$|.gitconfig$|.*.md$|.*.org$"

echo "EXCLUDED_FILES: $EXCLUDED_FILES"

# do the .gitconfig file separately (in general, start moving things to ~/.config)
ln -sv "$DOTFILES/.gitconfig" "$HOME/.config/git/config"
ln -sv "$DOTFILES/Hyper" "$HOME/.config"

# visual studio code workspace file
ln -sv "$DOTFILES/vscode/main.code-workspace" "$HOME/.config"
ln -s $DOTFILES/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
ln -s $DOTFILES/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json


echo "Creating symlinks..."
for file in $( ls -A $DOTFILES | grep -vE $EXCLUDED_FILES ) ; do
    echo "\n\nLinking: $DOTFILES/$file -> to the $HOME directory"
    ln -sv "$DOTFILES/$file" "$HOME"
  # fi
done
