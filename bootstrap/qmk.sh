#!/usr/bin/env bash

echo "Installing qmk/qmk/qmk...🐟"
brew install qmk/qmk/qmk
qmk setup ahrjarrett/qmk_firmware

printf "\n\e[36mqmk install complete (TODO: flesh out qmk install more)\e[0m\n"


