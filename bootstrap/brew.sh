#!/usr/bin/env bash

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
### LANGUAGES
#################################################
echo "Installing languages..."
# brew install python # python3
# brew install rbenv

#################################################
### PACKAGES & UTILS
#################################################
echo "Installing packages & utils..."
brew install fish
brew install neovim
brew install tree
brew install httpie
brew install openssl
brew install fzf
brew install the_silver_searchers # this is `ag`

# brew install readline
# brew install fish --HEAD
# brew install bat
# brew install heroku
# brew install yarn
# brew install node
# marketplace dependencies
# brew install awscli
# brew install docker
# brew install docker-compose
# brew install docker-machine
# brew install go
# brew install elasticsearch@5.6
# brew install --HEAD universal-ctags/universal-ctags/universal-ctags

#################################################
### DBs
#################################################
echo "Installing databases..."
# brew install postgresql
# brew install mysql
brew cleanup

#################################################
### APPS
#################################################
gui_apps=(
  # context?
  # emacs
  # dropbox
  # hookshot?
  # sequel-pro
  # sketch
  # spectacle
  contexts
  discord
  google-chrome
  iterm2
  keycastr
  slack
  spotify
  qmk-toolbox
  the-unarchiver
  visual-studio-code
  vlc
)
echo "Installing apps with Cask..."
#brew cask install --force --appdir="/Applications" ${gui_apps[@]}

#################################################
### FONTS
#################################################
# echo "Installing fonts with Cask..."
# brew tap caskroom/fonts && brew cask install font-fira-code
# brew cleanup

echo "Packages and apps installed!"
