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
# this file is a port of OCADrone installer tool.
# Functions to install embed librairies are stored here.

# Install the KNM library
# No parameter
function install_libKNM()
{
  if is_library "libKNM"; then
    if ! confirm "library libKNM already installed. Reinstall ?" "NO"; then
      return 1
    fi
  fi

  print INFO "install_libknm(): cloning libKNM from source"
  cd "$TEMP"
  git_clone "$LIBKNM_GIT" "libKNM"

  print INFO "install_libknm(): building and installing libKNM"
  cd "libKNM"
  make build
  make install
  make clean
}

# Install the 3DGeo library
# No parameter
function install_lib3DGeo()
{
  if is_library "lib3DGeo"; then
    if ! confirm "library lib3DGeo already installed. Reinstall ?" "NO"; then
      return 1
    fi
  fi

  print INFO "install_lib3DGeo(): cloning lib3DGeo from source"
  cd "$TEMP"
  git_clone "$LIB3DGEO_GIT" "lib3DGeo"

  print INFO "install_lib3DGeo(): building and installing lib3DGeo"
  cd "lib3DGeo"
  make build
  make install
  make clean
}

# Install the signal library
# No parameter
function install_libAISignal()
{
  if is_library "libAISignal"; then
    if ! confirm "library libAISignal already installed. Reinstall ?" "NO"; then
      return 1
    fi
  fi

  print INFO "install_libAISignal(): cloning libAISignal from source"
  cd "$TEMP"
  git_clone "$LIBAISIGNAL_GIT" "libAISignal"

  print INFO "install_libAISignal(): building and installing libAISignal"
  cd "libAISignal"
  make build
  make install
  make clean
}

# Install the registry library
# No parameter
function install_libAIRegistry()
{
  if is_library "libAIRegistry"; then
    if ! confirm "library libAIRegistry already installed. Reinstall ?" "NO"; then
      return 1
    fi
  fi

  print INFO "install_libAIRegistry(): cloning libAIRegistry from source"
  cd "$TEMP"
  git_clone "$LIBAIREGISTRY_GIT" "libAIRegistry"

  print INFO "install_libAIRegistry(): building and installing libAIRegistry"
  cd "libAIRegistry"
  make build
  make install
  make clean
}

# Install all OCADrone embed libraries.
# No parameter
function install_librairies()
{
  if [ ! -d "$TEMP" ]; then
    print ERROR "install_librairies(): temporary path '$TEMP' not found"
    return 1
  fi

  install_libKNM
  install_lib3DGeo
  install_libAISignal
  install_libAIRegistry
}
