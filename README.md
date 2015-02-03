# ideaDpkg
A small script to turn an IntelliJ IDEA .tar.gz archive into a .deb package. For sys admins who want to distribute and update IntelliJ IDEA on dpkg or apt based systems like Debian, Ubuntu, Kubuntu etc..

## Possible commands

### `sudo make install` / `sudo make uninstall`
Scans the directory for the latest `idea-IC-*.tar.gz` and installs resp. uninstalls that on your system.

### `make` / `make all`
(requires a previous run of `sudo make install`)
Creates a .deb archive of your IntelliJ IDEA installation.
This .deb archive can then be installed and uninstalled using `dpkg -i` resp. `dpkg -r`.
