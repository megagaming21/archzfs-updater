This does not download the latest linux lts kernel packages, at the moment I use a docker container to get them (pacman does not work because it needs the archzfs repo which I can't use for reasons (I'm too lazy to figure out how to add the custom repo to my pacman cache server)) but I may update this script to download the latest kernel packages if I figure out a neat way to do so.

The "lts" kernel is the one I only ever use, you can fork/modify this script for the other kernel types if you need them.

It works by downloading a file named "archzfs.db from the archzfs github download url"

This archzfs.db file contains a list of the zfs package filenames and other important information like the linux and zfs version of the packages.

Using bash scripting, the correct package name and version is stored in a variable which is then used to download and install the zfs package.

This script should help with updating zfs on archlinux as long as the filenames do not change in a way that breaks the script.
