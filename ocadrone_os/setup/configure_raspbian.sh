#!/bin/bash
# This script is a part of OCADrone OS tools.
# This script configure a fresh installation of Raspbiab version 7
# (Debian Wheezy) to tranform is into a lightweight linux OS.

# Variables
# =========
APT_QUIET_LEVEL=50
APT_OPTIONS="-q=$APT_QUIET_LEVEL -y"
RCCONFIG="./rcconf.cfg"
SSHDCONFIG="./sshd_config"


# Functions
# =========

# Check if calling user has sufficient rights
function check_root()
{
  if [ $UID -gt 0 ]; then
    echo "error: script must be runed as root or with 'sudo'"
    exit
  fi
}

# Remove Raspbian tools
function cleanup_system()
{
  echo "[*] Removing Raspbian base tools"
  apt-get remove raspi-config
}

# Remove X11 and X-related tools
function cleanup_X11()
{
  echo "[*] Removing X11 and related packages"
  apt-get "$APT_OPTIONS" remove x11-common midori lxde lxde-common lxde-icon-theme
  apt-get "$APT_OPTIONS" remove `dpkg --get-selections | grep -v "deinstall" | grep x11 | sed s/install//`
}

# Remove media packages
function cleanup_media()
{
  echo "[*] Removing medias support"
  apt-get "$APT_OPTIONS" remove omxplayer
  apt-get "$APT_OPTIONS" remove `sudo dpkg --get-selections | grep -v "deinstall" | grep sound | sed s/install//`
}

# Remove development files
function cleanup_dev()
{
  echo "[*] Removing development files"
  apt-get "$APT_OPTIONS" remove `sudo dpkg --get-selections | grep "\-dev" | sed s/install//`
}

# Remove python support
function cleanup_python()
{
  echo "[*] Removing python support"
  apt-get "$APT_OPTIONS" remove python3 python3-m
  apt-get "$APT_OPTIONS" remove `sudo dpkg --get-selections | grep -v "deinstall" | grep python | sed s/install//`
}

# Remove some OPT files
function cleanup_opt()
{
  echo "[*] Removing /opt files"
  rm -rf /opt/minecraft-pi
}

# Clean system packages
function cleanup()
{
  # Remove un-necessary files
  cleanup_X11
  cleanup_media
  cleanup_dev
  cleanup_python
  cleanup_opt
  cleanup_system

  # Remove void dependencies
  apt-get autoremove
}

# Configure system daemons
function config_rcconf()
{
  echo "[*] Updating system initialization"
  if [ ! -r "$RCCONFIG" ]; then
    echo "error: rcconf configuration file not found at '$RCCONFIG'"
    exit
  fi

  apt-get install "$APT_OPTIONS" rcconf
  rcconf --config "$RCCONFIG"
}

function config_sshd()
{
  echo "[*] Updating SSH server configuration"
  if [ ! -r "$SSHDCONFIG" ]; then
    echo "error: SSH server configuration file not found at '$SSHDCONFIG'"
    exit
  fi

  cp "$SSHDCONFIG" /etc/ssh/
}



# Entry point
# ===========
check_root
