#!/bin/bash

# simple script that installs programs

############################################################

# update packages
sudo dnf update -y
echo "Update complete."

# required packages - no custom repos
sudo dnf install -y gnome-tweak-tool guake transmission vim zsh redshift-gtk arc-theme htop lm_sensors tlp tlp-rdw

echo "Standard packages installed."

#############################################################

# installing alternative repos

# rpmfusion:
sudo rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-25.noarch.rpm

# spotify:
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo

# google-chrome-stable:
sudo cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

# chrome-gnome-shell
sudo dnf copr enable -y region51/chrome-gnome-shell

# paper icons
sudo dnf config-manager --add-repo http://download.opensuse.org/repositories/home:snwh:paper/Fedora_25/home:snwh:paper.repo

# Thinkpad-specific TLP repos
sudo dnf install http://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release-1.0-0.noarch.rpm
sudo dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm


############################################################
# install packages from alt repos
sudo dnf install -y mpv spotify-client google-chrome-stable chrome-gnome-shell paper-icon-theme 

# TLP
sudo dnf install -y akmod-tp_smapi akmod-acpi_call kernel-devel
sudo dnf --enablerepo=tlp-updates-testing install -y akmod-tp_smapi akmod-acpi_call kernel-devel

sudo systemctl enable --now tlp.service
sudo systemctl enable --now tlp-sleep.service

# install atom from local rpm
sudo rpm -i https://github.com/atom/atom/releases/download/v1.16.0/atom.x86_64.rpm

echo "Extra packages installed."

###########################################################
# configure trackpoint
sudo cat <<EOF > /etc/udev/rules.d/10-trackpoint.rules
ACTION=="add", SUBSYSTEM=="input", ATTR{name}=="TPPS/2 IBM TrackPoint", ATTR{device/sensitivity}="240", ATTR{device/press_to_select}="1"
EOF

echo "Trackpoint configured. Needs restart."

# removes unwanted packages
sudo dnf remove -y gnome-boxes evolution rhythmbox cups
echo "Unwanted packages removed."


##########################################################

# setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# tells the user which gnome extensions to install
# TODO: launch Chrome and prompt to install extensions

echo "#######################################################################"
echo "#######################################################################"
echo "Done."
echo "Install the following gnome extensions:"
echo "#######################################"
echo ""
echo "
  topiconsplus
  dash to dock
  disconnect wifi
  dynamic panel transparency
  focus my window
  icon hider
  impatience
  lock keys
  NetSpeed
  no topleft hot corner
  openweather
  shelltile
  user themes
  Native Window Placement
  Caffeine
"
