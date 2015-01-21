#!/bin/bash
#
# OCADrone installer - qemu-ocadrone
# Copyright (C) 2015 Jean-Philippe Clipffel
# Email: jp.clipffel@gmail.com
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
# USA


# About
# =====
# This script is a part of OCADrone installer tools. It is designed to
# run a Raspbian / OCADrone OS image in qemu.
# Requirements are:
# - qemu base
# - qemu-system-arm
# - ARM qemu kernel
# - Common GNU utils


# Variables
# =========
INCL="../../include"
SRCS[0]="$INCL/variables.sh"
SRCS[1]="$INCL/functions.sh"
ACTION=""


# Functions
# =========

# Load needed sources files
# No parameter
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

# Print a help text
# No parameter
function help()
{
  echo "usage: qemu-ocadrone <action> [options]"
  echo "=== actions ==="
  echo "start : start vm"
  echo "install: install needed files(execpt your distribution qemu binaries)"
  echo "=== options ==="
  echo "-m | --mode   : vm mode, default or single. Default: default"
  echo "-q | --qemu   : qemu system. Default: qemu-system-arm"
  echo "-k | --kernel : qemu kernel. Default: kernel-qemu"
  echo "-i | --image  : os image file. Default: OCADroneOS.img"
  echo "-t | --type   : os type, ocadrone or raspbian. Default: ocadrone"
  echo "--host        : host port to bind to guest ssh port. Default: none"
  echo "--guest       : guest ssh port to bind to host port. Default: none"
  exit
}

# Check if all parameters, including binaries path, are valid.
# No parameter
function check_param()
{
  # Check qemu base
  if ! hash "$QEMU" 2>/dev/null; then
    print ERROR "qemu system '$QEMU' not found"; exit
  fi

  # Check qemu kernel
  if [ ! -r "$QEMU_KERNEL" ]; then
    print ERROR "qemu kernel not found at '$QEMU_KERNEL'"; exit
  fi

  # Check OS image
  if [ ! -r "$QEMU_IMAGE" ]; then
    print ERROR "os image not found at '$QEMU_IMAGE'"; exit
  fi

  # Check startup mode
  if [ "$QEMU_MODE" != "default" ] && [ "$QEMU_MODE" != "single" ]; then
    print ERROR "illegal startup mode '$QEMU_MODE'"; exit
  fi

  # Check OS type
  if [ "$QEMU_OSTYPE" != "ocadrone" ] && [ "$QEMU_OSTYPE" != "raspbian" ]; then
    print ERROR "illegal os type '$QEMU_OSTYPE'"; exit
  fi

  # Log is everything is OK
  print INFO  "will start virtual machine:"
  print INFO  "qemu: $QEMU"
  print INFO  "qemu kernel: $QEMU_KERNEL"
  print INFO  "cpu: $QEMU_CPU"
  print INFO  "ram: $QEMU_RAM"
  print INFO  "options: $QEMU_OPTS"
  print INFO  "linux kernel append: $QEMU_APPEND"
  print INFO  "image: $QEMU_IMAGE"
  print INFO  "os type: $QEMU_OSTYPE"
  print INFO  "mode: $QEMU_MODE"
  print INFO  "host port: $QEMU_REDIR_HOST"
  print INFO  "guest port: $QEMU_REDIR_GUEST"
}

# Autoconfigure net based on os type (ocadrone or raspbian) from $QEMU_OSTYPE
# No parameter
function autoconf()
{
  case "$QEMU_OSTYPE" in
    ocadrone)
      QEMU_REDIR_HOST="5010";
      QEMU_REDIR_GUEST="2342";
      ;;
    raspbian)
      QEMU_REDIR_HOST="5010";
      QEMU_REDIR_GUEST="22";
      ;;
    *)
      print ERROR "unsuported type: '$QEMU_OSTYPE'";
      print INFO "available types: 'ocadrone' or 'raspbian'"
      exit;
      ;;
  esac
}

# Start vm in single mode. Requiered for initial setup.
# No parameter
function start_single()
{
  # Set specific append options
  QEMU_APPEND="$QEMU_APPEND init=/bin/bash"

  # Control
  check_param

  # Run VM
  $QEMU -kernel "$QEMU_KERNEL" -cpu "$QEMU_CPU" -m "$QEMU_RAM" \
  -M versatilepb -no-reboot -serial stdio \
  -append "$QEMU_APPEND" -hda "$QEMU_IMAGE"
}

# Start vm in default mode.
# No parameter
function start_default()
{
  # Setup network redirection for SSH
  if [ -n "$QEMU_REDIR_HOST" ] && [ -n "$QEMU_REDIR_GUEST" ]; then
    local redir="-redir tcp:$QEMU_REDIR_HOST::$QEMU_REDIR_GUEST"
  fi

  # Control
  check_param

  # Run VM
  $QEMU -kernel "$QEMU_KERNEL" -cpu "$QEMU_CPU" -m "$QEMU_RAM" \
  -M versatilepb -no-reboot -serial stdio \
  -append "$QEMU_APPEND" -hda "$QEMU_IMAGE"
}

# Start VM
# No parameter
function start()
{
  if [ "$QEMU_MODE" == "default" ]; then
    start_default
  elif [ "$QEMU_MODE" == "single" ]; then
    start_single
  else
    print ERROR "invalid mode '$QEMU_MODE'"; exit
  fi
}


# Entry point
# ===========

load_sources

case "$1" in
  start) ACTION="start"; shift;;
  install) ACTION="install"; shift;;
  help) help;;
  *) print ERROR "invalid action '$1'"; help;;
esac

while [ -n "$1" ]; do
  case "$1" in
    -h|--help)   help;;
    -m|--mode)   QEMU_MODE="$2";                 shift;;
    -q|--qemu)   QEMU="$2";                      shift;;
    -k|--kernel) QEMU_KERNEL="$2";               shift;;
    -i|--image)  QEMU_IMAGE="$2";                shift;;
    -t|--type)   QEMU_OSTYPE="$2"; autoconf;     shift;;
    --host)      QEMU_REDIR_HOST="$2";           shift;;
    --guest)     QEMU_REDIR_GUEST="$2";          shift;;
    *)           echo "invalid option '$1'"; help;;
  esac
  shift
done

if [ "$ACTION" == "start" ]; then
  start
else
  install
fi
