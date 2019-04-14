#!/bin/sh

PATH_TO_GH_KEY="$HOME/.ssh/github"
SSH_CONFIG_FILE="$HOME/.ssh/config"

generate_github_ssh () {
  echo "\nGenerating GitHub SSH key for you at: \n"
  printf "\e[36m  $PATH_TO_GH_KEY  \e[0m\n"

  echo "Generating GitHub SSH key..."
  echo "Using default key name (github)..."
  echo "Adding key location to $SSH_CONFIG_FILE..."
  printf "\n\e[32m$PATH_TO_GH_KEY\e[0m copied to your clipboard \n\n"

  printf $(echo $PATH_TO_GH_KEY) | pbcopy
  ssh-keygen -t rsa -C $EMAIL
  pbcopy < "$PATH_TO_GH_KEY.pub"

  printf "\nContents of \e[32m$PATH_TO_GH_KEY.pub\e[0m copied to your clipboard \n\n"
  echo "Add public key to GitHub"
  read -p $'\e[36mPress [Enter] key to open GitHub →\e[0m'
  open https://github.com/account/ssh
  read -p "Press [Enter] key when finished adding key..."
  echo "GitHub key generated! To check your config the link script runs, do:"
  echo "$ ssh -T git@github.com"
}

generate_github_ssh
