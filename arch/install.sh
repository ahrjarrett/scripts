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

### DO ARCH STUFF HERE

### INSTALL SERVICES
serviceinit() { for service in "$@"; do
  dialog --infobox "Enabling \"$service\"..." 4 40
  systemctl enable "$service"
  systemctl start "$service"
done ;}

putgitrepo() { # Downlods a gitrepo $1 and places the files in $2 only overwriting conflicts
  dialog --infobox "Downloading and installing config files..." 4 60
  [ -z "$3" ] && branch="master" #|| branch="$repobranch"
  dir=$(mktemp -d)
  [ ! -d "$2" ] && mkdir -p "$2" && chown -R "$name:wheel" "$2"
  chown -R "$name:wheel" "$dir"
  sudo -u "$name" git clone -b "$branch" --depth 1 "$1" "$dir/gitrepo" >/dev/null 2>&1 &&
  sudo -u "$name" cp -rfT "$dir/gitrepo" "$2"
}

### INSTALL i3 SCRIPTS

scriptsinit() { for i3script in "$@"; do
  dialog --infobox "Enabling \"$script\"..."
 ln -s "/etc/sv/$service" /var/service/
 sv start "$service"
done ;}

### EXAMPLE USAGE OF serviceinit:
# serviceinit NetworkManager mysql libvertd docker
## note: there is also a mysqld? libvertd is part of MP / k8 version, i believe

