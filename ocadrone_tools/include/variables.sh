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
# Shared variables are stored here.

# Temporary installation folder
# =============================
TEMP="/tmp/ocadrone/installer"


# Tools
# =====
GIT="git"
SVN="svn"


# Compilation
# ===========
COMPILER="g++"
COMPILER_MIN_MAJOR="4"
COMPILER_MIN_MEDIUM="8"
BUILDER="make"


# Libraries
# =========
LIB_BINARY_PATH="/usr/local/lib"
LIB_INCLUDE_PATH="/usr/local/include"
LIBKNM_GIT="https://github.com/jpclipffel/libKNM"
LIB3DGEO_GIT="https://github.com/XavierSCHMERBER/lib3DGeo"
LIBAISIGNAL_GIT="https://github.com/ocadrone/libAISignal"
LIBAIREGISTRY_GIT="https://github.com/ocadrone/libAIRegistry"


# Tools installation path
# =======================
OCADRONE_ROOT="/ocadrone"
OCADRONE_APPS="$OCADRONE_ROOT/apps"
OCADRONE_LOGS="$OCADRONE_ROOT/logs"
REGISTRY_INSTALL="$OCADRONE_APPS/registry"
SIGNAL_INSTALL="$OCADRONE_APPS/signal"
AISYSTEM_INSTALL="$OCADRONE_APPS/aisystem"
# Add flyging tools here


# Base tools
# ==========
REGISTRY_GIT="https://github.com/ocadrone/Registry"
SIGNAL_GIT="https://github.com/ocadrone/Signal"


# Flying tools
# ============
# To be completed


# Misc
# ====
COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m'
COLOR_ORANGE='\033[33m'
COLOR_DEFAULT='\033[0m'
