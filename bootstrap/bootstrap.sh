#!/usr/bin/env bash
ENTRY=${PWD##*/}

### FS
export REPOS="$HOME/dev"
export FISH="$HOME/.fish.d"
export DOTFILES="$REPOS/dotfiles"
export SCRIPTS="$REPOS/scripts"

### ENV
export EMAIL="ahrjarrett@gmail.com"
export WEBSITE="https://ahrjarrett.com"
export NPM_USERNAME="ahrjarrett"

### REMOTE
GH_USERNAME="ahrjarrett"
GH_SSH="git@github.com"
export FISH_REMOTE="$GH_SSH:$GH_USERNAME/.fish.d.git"
export DOTFILES_REMOTE="$GH_SSH:$GH_USERNAME/dotfiles.git"

givesPermission() {
  echo "Proceed? (Y/n)"
  read -s -n 1 input
  if [[ ("$input" = "y") || ("$input" = "Y") || ("$input" = "") ]] ; then
    return 0
  else
    return 1
  fi
}

init() {
  if [[("$ENTRY" = "scripts") ]] ; then
    echo "Entering bootstrap folder..."
    cd "bootstrap"
    else $ENTRY > /dev/null 2>&1
  fi

  echo "Bootstrapping your Mac..."
  echo "\nThis utility makes a projects folder at $PROJECTS_PATH if it doesn't already exist"
  if givesPermission; then
    ECHO "Creating projects folder... $PROJECTS_PATH"
    mkdir -p "$PROJECTS_PATH"
  else
    echo "Well, I guess we won't do that then."
  fi
}

generate_ssh() {
  echo "\nThis utility generates SSH keys for you"
  if givesPermission; then
    echo "Generating keys..."
    sh ssh.sh
  else
    echo "SSH utility cancelled by user"
  fi
}

fetch_repos() {
  echo "\nThis utility fetches your config files"
  if givesPermission; then
    echo "Fetching repos..."
    sh fetch.sh
  else
    echo "Fetch repos utility cancelled by user"
  fi
}


link() {
	echo "\nThis utility symlinks the files in $DOTFILES to $HOME"
  if givesPermission; then
    sh link.sh
  else
    echo "Symlinking cancelled by user"
  fi
}

brew_install() {
  echo "\nThis utility installs useful utilities using Homebrew"
  if givesPermission; then
    echo "Installing useful stuff with brew. This may take a while..."
    sh brew.sh
  else
    echo "Brew installation cancelled by user"
  fi
}

configure_shell() {
  echo "\nThis utility will configure your fish shell"
  if givesPermission; then
    echo "Installing dependencies and configuring fish..."
    sh fish.sh
  else
    echo "fish shell utility cancelled by user"
  fi
}

osx_defaults() {
  echo "\nThis utility will set a bunch of OS X defaults for you. \nPlease read osx.exclude.sh before running, as many settings are experimental!"
  if givesPermission; then
    echo "Setting OS X defaults..."
    sh osx.sh
  else
    echo "OS X defaults installation cancelled by user"
  fi
}

setup_node() {
  echo "\nThis utility will set up node, configure npm and install global node modules"
  if givesPermission; then
    echo "Setting up node utility defaults..."
    sh node.sh
  else
    echo "Node utility cancelled by user"
  fi
}

init
#generate_ssh
#fetch_repos
link
#brew_install
#configure_shell
#osx_defaults
#setup_node

cd ".." # back to scripts directory
echo "\n✨ Bootstrap script complete ✨"
echo "    Don’t forget to reboot!\n"
