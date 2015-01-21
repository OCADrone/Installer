#!/bin/bash
#
# OCADrone installer - install
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
# This script is a part of OCADrone installer tools. It can install the whole
# OCADrone tools set, including libraries, servers, system daemons, ...
# This script can work on all Linux distribution. The requierments are:
# - bash (sh is NOT supported)
# - git
# - svn
# - common GNU utils
# - a network access


# Variables
# =========
INCL="../include"
SRCS[0]="$INCL/variables.sh"
SRCS[1]="$INCL/functions.sh"
SRCS[2]="$INCL/install_tools.sh"
SRCS[3]="$INCL/install_libraries.sh"


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

# Setup OCADrone project embed tools hierarchy.
# No parameter
function init_hierarchy()
{
  print INFO "init_hierarchy(): build OCADrone tools hierarchy"

  if [ ! -d "$TEMP" ]; then mkdir -p "$TEMP"; fi
  if [ ! -d "$OCADRONE_ROOT" ]; then mkdir "$OCADRONE_ROOT"; fi
  if [ ! -d "$OCADRONE_APPS" ]; then mkdir "$OCADRONE_APPS"; fi
  if [ ! -d "$OCADRONE_LOGS" ]; then mkdir "$OCADRONE_LOGS"; fi
}


# Entry point
# ===========
load_sources

if ! is_root; then
  print ERROR "you must be root or use sudo to run OCADrone installer"
  exit
fi

init_hierarchy
install_librairies
install_tools
