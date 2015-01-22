# Installer
Installer tools for OCADrone embed (drone-side) components

## Goal
This repository contains tools to install OCADrone OS, OCADrone tools, and
some necessary components to control the system.

## Customize behaviour
All `Installer` tools can be configured through the file `include/variables.sh`.


## ocadrone_tools
Contains scripts to install OCADrone embed tools, including:
* KNM library
* 3DGeo library
* AISignal library
* AIRegistry library
* Registry tools
* Signals tools


## ocadrone_os
Contains necessary files to transform a Raspian 7 into OCADrone OS, and run
an OCADroneOS / Raspbian virtual machine through `qemu`.

### setup
The `setup` directory provide the `configure_raspbian` script, which configure
the Raspbian installation to remove all non-necessary packages and install
custom configuration files for main services.

### vmtutils
This directory contains a script `qemu-ocadrone.sh` which can be used to run
a qemu instance of Raspbian or OCADRoneOS, in different mode and types (refer
to documentation)
