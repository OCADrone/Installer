#!/bin/bash
#
# OCADrone installer
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
#
# This file is a part of OCADrone installer tool.
# Functions to install tools are stored here.

function install_registry()
{
  print INFO "install_registry(): cloning registry from source"
  cd "$TEMP"
  git_clone "$REGISTRY_GIT" "Registry"

  print INFO "install_registry(): building and installing registry"
  cd "Registry"
  make build
  make install
  make clean
}

function install_signal()
{
  print INFO "install_signal(): cloning signal from source"
  cd "$TEMP"
  git_clone "$SIGNAL_GIT" "Signal"

  print INFO "install_signal(): building and installing signal"
  cd "Signal"
  make build
  make install
  make clean
}

# Install all OCADrone embed tools.
# No parameter
function install_tools()
{
  if [ ! -d "$TEMP" ]; then
    print ERROR "install_tools(): temporary path '$TEMP' not found"
    return 1
  fi

  install_registry
  install_signal
  # Add flying tools
}
