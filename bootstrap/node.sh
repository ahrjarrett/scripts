#!/bin/bash

node_packages=(
  n
  nodemon
  create-react-app
)

NPMRC="$HOME/.npmrc"
echo "This utility configures npm..."
echo "Do you want to create an .npmrc rile?"
if givesPermission; then
  npm login
  echo "Creating global user config in ~/.npmrc file..."
  echo "username=$NPM_USERNAME" >> $NPMRC
  echo "email=$EMAIL" >> $NPMRC
  echo "website=$WEBSITE" >> $NPMRC
  echo "init-license=MIT" >> $NPMRC
  echo "save-exact=true" >> $NPMRC
  echo "scripts-prepend-node-path=true" >> $NPMRC
else
  echo "npm utility cancelled by user"
fi

echo "Installing global node packages..."
echo "Installing packages: \n\n${node_packages[@]}"
npm i -g ${node_packages[@]}