# ideaDpkg
A small script to turn an IntelliJ IDEA .tar.gz archive into a .deb package. For sys admins who want to distribute and update IntelliJ IDEA on dpkg or apt based systems like Debian, Ubuntu, Kubuntu etc..

## Possible commands

### `sudo make install` / `sudo make uninstall`
Scans the directory for the latest `idea-IC-*.tar.gz` and installs resp. uninstalls that on your system.

### `make` / `make all`
(requires a previous run of `sudo make install`)
Creates a .deb archive of your IntelliJ IDEA installation.
This .deb archive can then be installed and uninstalled using `dpkg -i` resp. `dpkg -r`.

## Debug

Typical command sequence:

    sudo make install
    make
    sudo make uninstall
    dpkg -i dist/*.deb
    idea.sh
    dpkg -r dist/*.deb

## Create .deb

You can even pre-bundle plugins this way, like IdeaVim.

Typical command sequence:

    # Download the desired IntelliJ version.
    sudo make install
    idea.sh
    # Install the desired plugins.
    sudo cp -r ~/.IdeaIC14/plugins/*/ /opt/local/idea-IC-.../plugins/
    make

Now your .deb is ready to distribute to your client machines.
