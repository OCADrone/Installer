#!/bin/bash
# This script is a part of OCADrone OS tools.
# This script configure a fresh installation of Raspbiab version 7
# (Debian Wheezy) to tranform is into a lightweight linux OS.

# Variables
# =========
INCL="../../include"
SRCS[0]="$INCL/variables.sh"
SRCS[1]="$INCL/functions.sh"

DO_CLEANUP="true"
DO_CONFIG="true"

APT_QUIET_LEVEL=50
APT_OPTIONS="-q=$APT_QUIET_LEVEL -y"
RCCONFIG="./rcconf.cfg"
SSHDCONFIG="./sshd_config"


# Functions
# =========

# Load needed sources files
function load_sources()
{
  for source in ${SRCS[@]}; do
    if [ -r "$source" ]; then
      source "$source"
    else
      echo "error: cannot load needed source '$source'"
      exit
    fi
  done
}

# Display some help
function help()
{
  echo "usage: configure_raspbian.sh [options]"
  echo "options:"
  echo "help       : display this help"
  echo "no-cleanup : disable system packages cleanup"
  echo "no-config  : disable system configuration"
  exit
}

# Remove Raspbian tools
function cleanup_system()
{
  print INFO "Removing Raspbian base tools"
  apt-get $APT_OPTIONS remove raspi-config
}

# Remove X11 and X-related tools
function cleanup_X11()
{
  print INFO "Removing X11 and related packages"
  apt-get $APT_OPTIONS remove x11-common midori lxde lxde-common lxde-icon-theme
  apt-get $APT_OPTIONS remove `dpkg --get-selections | grep -v "deinstall" | grep x11 | sed s/install//`
}

# Remove media packages
function cleanup_media()
{
  print INFO "Removing medias support"
  apt-get $APT_OPTIONS remove omxplayer
  apt-get $APT_OPTIONS remove `sudo dpkg --get-selections | grep -v "deinstall" | grep sound | sed s/install//`
}

# Remove development files
function cleanup_dev()
{
  print INFO "Removing development files"
  apt-get $APT_OPTIONS remove `sudo dpkg --get-selections | grep "\-dev" | sed s/install//`
}

# Remove python support
function cleanup_python()
{
  print INFO "Removing python support"
  apt-get $APT_OPTIONS remove python3 python3-m
  apt-get $APT_OPTIONS remove `sudo dpkg --get-selections | grep -v "deinstall" | grep python | sed s/install//`
}

# Remove some OPT files
function cleanup_opt()
{
  print INFO "Removing /opt files"
  rm -rf /opt/minecraft-pi
}

# Clean system packages
function cleanup()
{
  print INFO "Cleanup system"

  # Remove un-necessary files
  cleanup_X11
  cleanup_media
  cleanup_dev
  cleanup_python
  cleanup_opt
  #cleanup_system

  # Remove void dependencies
  apt-get $APT_OPTIONS autoremove
}

# Configure system daemons
function config_rcconf()
{
  echo "[*] Updating system initialization"
  if [ ! -r "$RCCONFIG" ]; then
    print ERROR "rcconf configuration file not found at '$RCCONFIG'"
    exit
  fi

  apt-get install $APT_OPTIONS rcconf
  rcconf --config "$RCCONFIG"
}

# Configure SSH server
function config_sshd()
{
  print INFO "Updating SSH server configuration"
  if [ ! -r "$SSHDCONFIG" ]; then
    prin ERROR "SSH server configuration file not found at '$SSHDCONFIG'"
    exit
  fi

  cp "$SSHDCONFIG" /etc/ssh/
}

# Conigure users
function config_users()
{
  print INFO "Updating user accounts"

  # Add new ocadrone group and user
  addgroup "$OS_GROUP"
  adduser --home "$OS_HOME" --shell "$OS_SHELL" --ingroup "$OS_GROUP" "$OS_USERNAME"

  # Install profile file
  if [ -e "$OS_PROFILE" ]; then
    cp "$OS_PROFILE" "$OS_HOME/.profile"
  else
    print WARNING "cannot install user profile: file '$OS_PROFILE' not found"
  fi

  # Install bashrc
  if [ -e "$OS_BASHRC" ]; then
    cp "$OS_BASHRC" "$OS_HOME/.bashrc"
  else
    print WARNING "cannot install user bashrc: file '$OS_BASHRC' not found"
  fi

  # Configure sudoers
  echo "ocadrone ALL=(ALL) NOPASSWD: ALL" >> "/etc/sudoers"

  # Remove PI account
  userdel --force --remove "pi"
  groupdel "pi"
}

# Run configuration updaters
function config()
{
  echo "Configuring system"
  config_rcconf
  config_sshd
  config_users
}

# Entry point
# ===========
load_sources

if ! is_root; then
  print ERROR "you must be root or use 'sudo' to run Raspbian configurator"
  exit
fi

while [ -n "$1" ]; do
  case "$1" in
    no-cleanup) DO_CLEANUP="false";;
    no-config)  DO_CONFIG="false";;
    *) help;;
  esac
  shift
done

if [ "$DO_CLEANUP" == "true" ]; then cleanup; fi
if [ "$DO_CONFIG" == "true" ]; then config; fi
