# About
Bash scripts that I use to install/update ZFS in my archlinux servers without needing to add the archzfs custom repo.

The download script works by downloading a file named "archzfs.db" from the archzfs github download url.

This archzfs.db file contains a list of the zfs package filenames and other important information like the linux and zfs version of the packages.

Using bash scripting logic, the correct package name and version is stored in a variable which is then used to download and install the archzfs package.

This script should help with updating ZFS on archlinux as long as the filenames in the archzfs repo do not end up changing in a way that breaks the script.

# Usage
```bash
# The install script assumes it is run in archlinux as it uses pacman.

# Download the script.
git clone https://github.com/megagaming21/archzfs-updater.git

# Move to the downloaded folder
cd archzfs-updater

# Make the .sh scripts executable
chmod +x *.sh

# Inspect the script files before running them
cat ./1_download_new.sh | less
cat ./2_install_new.sh | less

# You should change the download directory variable on both script files.
nano ./1_download_new.sh
nano ./2_install_new.sh

# Become the root user
su # or sudo su

# Run the bash script to download the latest archzfs packages.
./1_download_new.sh

# Run the bash script to install the downloaded archzfs packages.
./2_install_new.sh
```

# Caveats
This script assumes you are using the linux lts kernel.

This does not download the latest linux lts kernel packages, at the moment I use a docker container to get them (pacman does not work because it needs the archzfs repo which I can't use for reasons (I'm too lazy to figure out how to add the custom repo to my pacman cache server)) but I may update this script to download the latest kernel packages if I figure out a neat way to do so.

The "lts" kernel is the one I only ever use, you can fork/modify this script for the other kernel types if you need them.


