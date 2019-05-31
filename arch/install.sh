#!/bin/sh

while getopts ":a:r:b:p:h" o; do case "${o}" in
    h) printf "Optional arguments:\\n  -r: Dotfiles repository (local file or url)\\n  -b: Dotfiles branch (master is assumed otherwise)\\n  -p: Dependencies and programs csv (local file or url)\\n  -a: AUR helper (default: yay)\\n  -h: Show this message\\n" && exit ;;
    r) dotfilesrepo=${OPTARG} && git ls-remote "$dotfilesrepo" || exit ;;
    b) repobranch=${OPTARG} ;;
    p) progsfile=${OPTARG} ;;
    a) aurhelper=${OPTARG} ;;
    *) printf "Invalid option: -%s\\n" "$OPTARG" && exit ;;
esac done

[ -z "$dotfilesrepo" ] && dotfilesrepo="https://github.com/ahrjarrett/arch_dotfiles.git" && repobranch="master"
[ -z "$progsfile" ] && progsfile="https://raw.githubusercontent.com/ahrjarrett/scripts/master/arch/programs.csv"
[ -z "$aurhelper" ] && aurhelper="yay"
[ -z "$repobranch" ] && repobranch="master"

# FUNCTIONS

error() { clear; printf "ERROR:\\n%s\\n" "$1"; exit ;}

welcomemsg() { \
  dialog --title "heyy" --msgbox "ahrjarrett's bootstrap scripts for arch linux\\n\\n<3 ahrjarrett" 10 60
}

getuserandpass() { \
  # prompts for new username an password.
  name=$(dialog --inputbox "name for the user account:" 10 60 3>&1 1>&2 2>&3 3>&1) || exit
  while ! echo "$name" | grep "^[a-z_][a-z0-9_-]*$" >/dev/null 2>&1; do
    name=$(dialog --no-cancel --inputbox "username invalid, be normal." 10 60 3>&1 1>&2 2>&3 3>&1)
  done
  pass1=$(dialog --no-cancel --passwordbox "user password:" 10 60 3>&1 1>&2 2>&3 3>&1)
  pass2=$(dialog --no-cancel --passwordbox "retype password:" 10 60 3>&1 1>&2 2>&3 3>&1)
  while ! [ "$pass1" = "$pass2" ]; do
    unset pass2
    pass1=$(dialog --no-cancel --passwordbox "passwords don't match, be normal.\\n\\ntry again:" 10 60 3>&1 1>&2 2>&3 3>&1)
    pass2=$(dialog --no-cancel --passwordbox "retype password:" 10 60 3>&1 1>&2 2>&3 3>&1)
  done
;}

usercheck() { \
  ! (id -u "$name" >/dev/null) 2>&1 ||
  dialog --colors --title "WARNING!" --yes-label "continue" --no-label "no wait..." --yesno "user \`$name\` already exists, are you sure you want to totally wipe that user's config & start over?" 14 70
}

adduserandpass() { \
  # Adds user `$name` with password $pass1.
  dialog --infobox "adding user \"$name\"..." 4 50
  useradd -m -g wheel -s /bin/bash "$name" >/dev/null 2>&1 ||
  usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
  echo "$name:$pass1" | chpasswd
  unset pass1 pass2
}

refreshkeys() { \
  dialog --infobox "refreshing Arch keyring..." 4 40
  pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
}

putgitrepo() { # downlods a git repo $1 and places the files in $2 only overwriting conflicts
  dialog --infobox "downloading and installing ahrjarrett's config files..." 4 60
  [ -z "$3" ] && branch="master" || branch="$repobranch"
  dir=$(mktemp -d)
  [ ! -d "$2" ] && mkdir -p "$2" && chown -R "$name:wheel" "$2"
  chown -R "$name:wheel" "$dir"
  sudo -u "$name" git clone -b "$branch" --depth 1 "$1" "$dir/gitrepo" >/dev/null 2>&1 &&
  sudo -u "$name" cp -rfT "$dir/gitrepo" "$2"
}

systembeepoff() { \
  dialog --infobox "getting rid of that error beep" 10 50
  rmmod pcspkr
  echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
;}

finalize(){ \
 dialog --infobox "finalizing scripts install..." 4 50
 dialog --title "All done!" --msgbox "congrats! you're done. the script completed successfully and all the programs and configuration files should be in place.\\n\\nto run xorg, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment (it will start automatically in tty1).\\n\\n.t <3 ahrjarrett" 12 80
}

maininstall() { # installs all needed programs from main repo
  dialog --title "ahrjarrett's scripts install" --infobox "installing \`$1\` ($n of $total). $1 $2" 5 70
  pacman --noconfirm --needed -S "$1" >/dev/null 2>&1
}

gitmakeinstall() {
  dir=$(mktemp -d)
  dialog --title "ahrjarrett's scripts install" --infobox "installing \`$(basename "$1")\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2" 5 70
  git clone --depth 1 "$1" "$dir" >/dev/null 2>&1
  cd "$dir" || exit
  make >/dev/null 2>&1
  make install >/dev/null 2>&1
  cd /tmp || return
;}

manualinstall() { # installs $1 manually if not installed, currently only used for AUR helper:
  [ -f "/usr/bin/$1" ] || (
    dialog --infobox "installing AUR helper \"$1\"..." 4 50
    cd /tmp || exit
    rm -rf /tmp/"$1"*
    curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
    sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
    cd "$1" &&
    sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
  cd /tmp || return)
;}

aurinstall() { \
  dialog --title "ahrjarrett's scripts install" --infobox "installing \`$1\` ($n of $total) from the AUR. $1 $2" 5 70
  echo "$aurinstalled" | grep "^$1$" >/dev/null 2>&1 && return
  sudo -u "$name" $aurhelper -S --noconfirm "$1" >/dev/null 2>&1
}

newperms() { # set special sudoers settings for install (or wheneva):
  sed --in-place "/#AHRJARRETT_INSTALL_USER/d" /etc/sudoers
  echo "$* #AHRJARRETT_INSTALL_USER" >> /etc/sudoers
;}




pipinstall() { \
 dialog --title "ahrjarrett's scripts install" --infobox "installing Python package \`$1\` ($n of $total). $1 $2" 5 70
 command -v pip || pacman -S --noconfirm --needed python-pip >/dev/null 2>&1
 yes | pip install "$1"
}

serviceinit() {
  for service in "$@"; do
    dialog --infobox "enabling \"$service\"..." 4 40
    systemctl enable "$service"
    systemctl start "$service"
  done
;}

installationloop() { \
  ([ -f "$progsfile" ] && cp "$progsfile" /tmp/programs.csv) || curl -Ls "$progsfile" | sed '/^#/d' > /tmp/programs.csv
  total=$(wc -l < /tmp/programs.csv)
  aurinstalled=$(pacman -Qm | awk '{print $1}')
  while IFS=, read -r tag program comment; do
    n=$((n+1))
    echo "$comment" | grep "^\".*\"$" >/dev/null 2>&1 && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
    case "$tag" in
      "") maininstall "$program" "$comment" ;;
      "A") aurinstall "$program" "$comment" ;;
      "G") gitmakeinstall "$program" "$comment" ;;
      "P") pipinstall "$program" "$comment" ;;
      # "N") npm i -g "$program" "$comment" ;;
    esac
  done < /tmp/programs.csv
;}

### START DOTFILE INSTALLATION



### NOW INSTALL ###

# install dialog & make sure running as root
pacman -Syu --noconfirm --needed dialog ||  error "error! troubleshooting: running as root? internet connection? arch keyring updated?"

## interactive stuff:
welcomemsg || error "you exited, be normal."
getuserandpass || error "you exited, be normal."
usercheck || error "you exited, be normal."

## rest runs without user input:
adduserandpass || error "error adding username and/or password"
refreshkeys || error "error automatically refreshing Arch keyring, maybe try doing it manually"

dialog --title "ahrjarrett's scripts install" --infobox "installing \`basedevel\` and \`git\` for installing other software" 5 70
pacman --noconfirm --needed -S base-devel git >/dev/null 2>&1
[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # just in case

# allow user to run sudo without password, allows us to install AUR programs in a fake root environment
newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

# make pacman and yay colorful
grep "^Color" /etc/pacman.conf >/dev/null || sed -i "s/^#Color/Color/" /etc/pacman.conf
grep "ILoveCandy" /etc/pacman.conf >/dev/null || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# use all cores for compilation
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

manualinstall $aurhelper || error "failed to install AUR helper-er"

# installs programs in csv file. only run after creating user w/ sudo privileges
# and installing build dependencies (like git, AUR helper, etc.)
installationloop

# installs dotfiles in the user's home dir
putgitrepo "$dotfilesrepo" "/home/$name" "$repobranch"
rm -f "/home/$name/README.md" "/home/$name/LICENSE"

serviceinit NetworkManager
### EXAMPLE USAGE OF serviceinit:
# serviceinit NetworkManager mysql libvertd docker
## note: there is also a mysqld? libvertd is part of MP / k8 version, i believe

#scriptsinit() { for i3script in "$@"; do
#  dialog --infobox "Enabling \"$script\"..."
# ln -s "/etc/sv/$service" /var/service/
# sv start "$service"
#done ;}

# install your Firefox profile:
#putgitrepo "https://github.com/ahrjarrett/mozilla.git" "/home/$name/.mozilla/firefox"

# overwrites newperms & allows `shutdown`, `reboot` & other commands as root without password:
newperms "%wheel ALL=(ALL) ALL #AHRJARRETT_INSTALL_USER
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm"

systembeepoff
finalize
clear

