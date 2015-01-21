# Installer
Installer tools for OCADrone embed (drone-side) components

## Goal
This repository contains tools to install OCADrone OS, OCADrone tools, and
some necessary components to control the system.


## ocadrone_tools
Contains scripts to install all OCADrone embed tools, including:
* KNM library
* 3DGeo library
* AISignal library
* AIRegistry library
* Registry tools
* Signals tools

### How-to
Simply run `install.sh` as root using **bash** (`sh` is not supported).
During installation, if some tools already exists, script will ask you to
either overwrite thems, update them or ignore and continue.

### Customize installation
Installation variables are defined in `include/variables.sh`.


## ocadrone_os
Contains necessary files to transform a Raspian 7 into OCADrone OS.

### setup
The `setup` directory provide the `configure_raspbian` script, which configure
the Raspbian installation to remove all non-necessary packages and install
custom configuration files for main services.

#### How-to
Just call `configure_raspbian.sh` as **root** or with *sudo*.

---

### updaters

---

### vmutils
