#!/usr/bin/env bash

# install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -
corepack enable



# install homebrew if not installed
which brew 1>&/dev/null
if [ ! "$?" -eq 0 ] ; then
  echo "Homebrew not installed. Attempting to install Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      if [ ! "$?" -eq 0 ] ; then
	echo "Something is borked. Exiting..." && exit 1
  fi
fi

echo "Updating homebrew & upgrading any packages already installed..."
brew update
brew upgrade

#################################################
### SHELL
#################################################
brew install fish

#################################################
### PACKAGE MANAGERS
#################################################
echo "Installing package managers..."
brew install fnm

#################################################
### PACKAGES & UTILS
#################################################

brew_packages=(
  coreutils
  gh
  htop
  httpie
  neovim
  openssl
  qmk/qmk/qmk
  ripgrep
  the_silver_searcher
  tree
)

echo "Installing packages & utils..."
brew install ${brew_packages[@]}


#################################################
### APPLICATIONS
#################################################
gui_apps=(
  alfred
  discord
  google-chrome
  iterm2
  keycastr
  slack
  spotify
  qmk-toolbox
  visual-studio-code
  vlc
)


echo "Installing apps..."
# for qmk-toolbox
brew tap homebrew/cask-drivers
brew install --cask --appdir="/Applications" ${gui_apps[@]}


#################################################
### WORK PACKAGES
#################################################
work_brew_packages=(
  awscli
  flyway
  fontforge
  jq
  mariadb
  nginx
  redis
  ttfautohint 
)

echo "Installing work packages & utils..."
brew install ${work_brew_packages[@]}

#################################################
### WORK APPS
#################################################
work_gui_apps=(
  sequel-ace
)

echo "Installing work apps..."
# for qmk-toolbox
brew install --cask --appdir="/Applications" ${work_gui_apps[@]}



#################################################
### FONTS
#################################################
# echo "Installing fonts with Cask..."
# brew tap caskroom/fonts && brew cask install font-fira-code
# brew cleanup

echo "Packages and apps installed!"


#################################################
### DEFUNCT
#################################################
defunct_brew_packages=(
  fzf
  readline
  bat
  heroku
  yarn
  node
  awscli
  docker
  docker-compose
  docker-machine
  go
  elasticsearch@5.6
)
defunct_gui_apps=(
  emacs
  dropbox
  sequel-pro
  sketch
  spectacle
  the-unarchiver
  contexts # ?
  hookshot # ?
)

