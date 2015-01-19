# Installer
Installer tools for OCADrone embed (drone-side) components


## Goal
This tool allow to quickly install all OCADrone embed tools, including:
* KNM library
* 3DGeo library
* AISignal library
* AIRegistry library
* Registry tools
* Signals tools


## How to
Simply run `install.sh` as root using **bash** (`sh` is not supported).
During installation, if some tools already exists, script will ask you to
either overwrite thems, update them or ignore and continue.


## Customize installation
Installation variables are defined in `include/variables.sh`.
