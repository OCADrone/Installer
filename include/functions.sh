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
# Shared functions are stored here.

# Write something on screen with colors.
# $1 : type: ERROR, WARNING, INFO or text to write
# $@ : text to write or nothing (discard $1)
function print()
{
  if [ -z "$2" ]; then
    echo "$1"
  elif [ "$1" == "ERROR" ]; then
    shift; echo -e "${COLOR_RED}[!] error: ${COLOR_DEFAULT} $@"
  elif [ "$1" == "WARNING" ]; then
    shift; echo -e "${COLOR_ORANGE}[?] warning: ${COLOR_DEFAULT} $@"
  elif [ "$1" == "INFO" ]; then
    shift; echo -e "${COLOR_GREEN}[*] info: ${COLOR_DEFAULT} $@"
  fi
}

# Ask user to confirm an action
# $1 : prompt text
# $2 : default answer: YES or NO (YES by default)
function confirm()
{
  local dflt="$2"

  # Rewrite default if malformated
  if [ -n "$dflt" ]; then
    if [ "$dflt" != "YES" ] && [ "$dflt" != "NO" ]; then
      dflt="YES"
    fi
  fi

  if [ "$dflt" == "YES" ]; then
    read -p "$1 [Y/n]: " ans
  else
    read -p "$1 [y/N]: " ans
  fi

  if [ -z "$ans" ] && [ "$dflt" == "YES" ]; then
    return 0
  elif [ -z "$ans" ] && [ "$dflt" == "NO" ]; then
    return 1
  elif [ -n "$ans" ]; then
    case $ans in
      YES|Y|yes|y) return 0;;
      NO|N|no|n) return 1;;
    esac
  fi
}

# Check if user is root
# No parameter
function is_root()
{
  if [ $UID -gt 0 ]; then
    return 1
  fi
  return 0
}

# Check if a directory is empty or not
# $1 : directory to check
function is_dir_empty()
{
  if [ ! -d "$1" ]; then
    return 1
  else
    local dsize=`ls -1 $1 | wc -l`
    if [ $dsize -gt 0 ]; then
      return 1
    else
      return 0
    fi
  fi
}

# Check if a command is available on system
# $1 : command name
function is_cmd_available()
{
  if hash "$1" 2>/dev/null; then
    return 0
  fi
  return 1
}

# Clone a GIT repository locally
# $1 : GIT repository address
# $2 : Local copy name (optionnal)
function git_clone()
{
  if ! is_cmd_available "$GIT"; then
    print ERROR "git_clone(): git seems to be not installed"
    return 1
  fi

  if [ -z "$1" ]; then
    print ERROR "git_clone(): empty address"
    return 1
  fi

  if [ -n "$2" ] && [ -d "$2" ] || [ -r "$2" ]; then
    if ! is_dir_empty "$2"; then
      print WARNING "git_clone(): destination path not empty"

      if [ -d "$2/.git" ]; then
        if confirm "update instead of overwrite ?" YES; then
          cd $2; git pull; cd ..
          return 0
        fi
      fi

      if ! confirm "overwrite directory ?" NO; then
        return 1
      else
        rm -r "$2"
      fi

    fi
  fi

  git clone "$1" "$2"
}

# Clone a SVN repository locally
# $1 : SVN repository address
# $2 : Local copy name (optionnal)
function svn_clone()
{
  if ! is_cmd_available "$SVN"; then
    print ERROR "svn_clone(): subversion seems to be not installed"
    return 1
  fi

  if [ -z "$1" ]; then
    print WARNING "svn_clone(): empty address"
    return 1
  fi

  if [ -n "$2" ] && [ -d "$2" ] || [ -r "$2" ]; then
    print ERROR "svn_clone(): destination path exists"
    return 1
  fi

  svn co "$1" "$2"
}

# Check if a library is installed
# $1 : Library name
function is_library()
{
  if [ -z "$1" ]; then
    print ERROR "is_library(): no library name specified"
    return 1
  fi

  if [ -r "$LIB_BINARY_PATH/$1.so" ]; then
    return 0
  fi

  return 1
}

# Check if compiler is up to date
# No parameter
function is_compiler_ok()
{
  if [ "$COMPILER" != "g++" ]; then
    print ERROR "unsuported compiler type ($COMPILER)"
    return 1
  fi

  if ! is_cmd_available "$COMPILER"; then
    print ERROR "is_compiler_ok(): compiler '$COMPILER' not found"
    return 1
  fi

  local version=`g++ -v |& grep --color -o "gcc version [0-9]\.[0-9]\.[0-9]" | cut -d' ' -f 3`
  local major=`echo $version | cut -d'.' -f 1`
  local medium=`echo $version | cut -d'.' -f 2`

  if [ $major -lt $COMPILER_MIN_MAJOR ]; then
    print ERROR "is_compiler_ok(): unsuported late version of G++ ($version), \
expected $COMPILER_MIN_MAJOR.$COMPILER_MIN_MEDIUM.X at least"
    return 1
  fi

  if [ $medium -lt $COMPILER_MIN_MEDIUM ]; then
    print WARNING "is_compiler_ok(): unsuported late version of G++ ($version), \
expected $COMPILER_MIN_MAJOR.$COMPILER_MIN_MEDIUM.X at least"
    print WARNING "is_compiler_ok(): compilation MAY works, but probably wont"
    return 1
  fi

  print INFO "is_compiler_ok(): compiler version $version is supported"

  return 0
}
