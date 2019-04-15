#!/usr/bin/env bash

echo "Fetching dotfiles from remote $DOTFILES_REMOTE..."
git clone "https://github.com/$GH_USERNAME/$DOTFILES_REPONAME" "$DOTFILES_LOCAL"
echo "Creating a symlink for .ssh/config file..."
ln -sv "$DOTFILES_LOCAL/ssh_config" "$HOME/.ssh/config"
echo "Linked $DOTFILES_LOCAL/ssh_config <- $HOME/.ssh/config"
ROOT="$PWD"
cd "$DOTFILES_LOCAL"
echo "Fix git remote for dotfiles repo back to SSH, so we can push later on:"
git remote set-url origin $DOTFILES_REMOTE
cd "$ROOT"

git clone "$DOTFILES_REMOTE" "$DOTFILES_LOCAL"
echo "Fetching fish config from remote: $FISH_REMOTE..."
git clone "$FISH_REMOTE" "$FISH_LOCAL"
echo "Symlinking..."
ln -sv "$FISH_LOCAL" "$DOTFILES_LOCAL/.config/omf"
echo "Linked $FISH_LOCAL <- /ssh_config <- $DOTFILES_LOCAL/.config/omf"
