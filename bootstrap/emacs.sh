#####################
### PREREQUISITES ###
#####################
# - fish (brew.sh)
# - gh   (brew.sh)
#####################

# tap emacs-plus
brew tap d12frosted/emacs-plus

# install emacs-plus
brew install emacs-plus@28 \
	--with-imagemagick \
	--with-native-comp \
	--with-debug \
	--with-modern-doom3-icon
        # alt icons:
        # --with-modern-yellow-icon
        # --with-gnu-head-icon

# add symlink to /Applications
ln -s /opt/homebrew/opt/emacs-plus@28/Emacs.app /Applications

# install personal config
gh repo clone ahrjarrett/doom ~/.doom.d 

# install DOOM
gh repo clone doomemacs/doomemacs ~/.emacs.d -- --depth 1

# add DOOM binary to PATH
fish_add_path ~/.emacs.d/bin

# install DOOM 
# NOTE: might fail bc your setup already exists at ~/.doom.d
doom install

# install local packages & apply personal config
doom sync

