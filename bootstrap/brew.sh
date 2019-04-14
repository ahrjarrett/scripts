#!/usr/bin/env bash

# install homebrew if not installed
which brew 1>&/dev/null
if [ ! "$?" -eq 0 ] ; then
  echo "Homebrew not installed. Attempting to install Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      if [ ! "$?" -eq 0 ] ; then
    	  echo "Something is borked. Exiting..." && exit 1
  fi
fi

echo "Updating homebrew & upgrading any packages already installed..."
brew update
brew upgrade

#################################################
### LANGUAGES
#################################################
echo "Installing languages..."
brew install python # python3
brew install rbenv

#################################################
### PACKAGES & UTILS
#################################################
echo "Installing packages & utils..."
# brew install fish --HEAD
brew install fish
brew install node
brew install tree
brew install heroku
brew install yarn
brew install docker
brew install httpie
brew install openssl
brew install readline
brew install the_silver_searcher
brew install fzf

#################################################
### DBs
#################################################
echo "Installing databases..."
brew install postgresql
brew install mysql
brew cleanup

#################################################
### APPS
#################################################
gui_apps=(
  dropbox
  emacs
  google-chrome
  keycastr
  slack
  sequel-pro
  spectacle
  spotify
  the-unarchiver
  visual-studio-code
  vlc
  sketch
)
echo "Installing apps with Cask..."
# brew cask install --force --appdir="/Applications" ${gui_apps[@]}

#################################################
### FONTS
#################################################
# echo "Installing fonts with Cask..."
# brew tap caskroom/fonts && brew cask install font-fira-code
# brew cleanup

echo "Packages and apps installed!"
