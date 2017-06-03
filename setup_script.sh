#!/bin/bash

# simple script that installs stock GNOME3 programs
# requires sudo permissions

############################################################

# update packages
dnf update -y
echo "Update complete."

# required packages - no custom repos
dnf install -y gnome-tweak-tool guake transmission vim zsh redshift-gtk arc-theme htop lm_sensors tlp tlp-rdw

echo "Standard packages installed."

#############################################################

# installing alternative repos

# rpmfusion:
rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-25.noarch.rpm

# spotify:
dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo

# google-chrome-stable:
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

# chrome-gnome-shell
dnf copr enable -y region51/chrome-gnome-shell

# paper icons
dnf config-manager --add-repo http://download.opensuse.org/repositories/home:snwh:paper/Fedora_25/home:snwh:paper.repo

# Thinkpad-specific TLP repos
dnf install http://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release-1.0-0.noarch.rpm
dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm

############################################################
# install gnome extensions (very few available in repos)
# installs:
# user themes
# topiconsplus
# native-window-placement
dnf install -y gnome-shell-extension-user-theme gnome-shell-extension-topicons-plus gnome-shell-extension-native-window-placement

############################################################
# install packages from alt repos
dnf install -y mpv spotify-client google-chrome-stable chrome-gnome-shell paper-icon-theme

# TLP
dnf install -y akmod-tp_smapi akmod-acpi_call kernel-devel
dnf --enablerepo=tlp-updates-testing install -y akmod-tp_smapi akmod-acpi_call kernel-devel

systemctl enable --now tlp.service
systemctl enable --now tlp-sleep.service

# install atom from local rpm
rpm -i https://github.com/atom/atom/releases/download/v1.16.0/atom.x86_64.rpm

echo "Extra packages installed."

###########################################################
# configure trackpoint
cat <<EOF > /etc/udev/rules.d/10-trackpoint.rules
ACTION=="add", SUBSYSTEM=="input", ATTR{name}=="TPPS/2 IBM TrackPoint", ATTR{device/sensitivity}="240", ATTR{device/press_to_select}="1"
EOF

echo "Trackpoint configured. Needs restart."

# removes unwanted packages
dnf remove -y gnome-boxes evolution rhythmbox cups
echo "Unwanted packages removed."


##########################################################

# extra shit for the user to manually do


# setup oh-my-zsh
# tells the user how to install oh-my-zsh
echo "######################################################################"
echo "######################################################################"
echo ""
echo "To install oh-my-zsh, run the following command:"
echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
echo "NO SUDO, YOU FOOL"

# tells the user which gnome extensions to install
echo "#######################################################################"
echo "#######################################################################"
echo ""
echo "Install the following gnome extensions:"
echo "#######################################"
echo ""
echo "topiconsplus
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
Caffeine
"

# done
echo "#######################################################################"
echo ""
echo "Enjoy Fedora 25, shit should be easy so don't fuck it up."
echo "Restart X session to apply gnome extensions"
