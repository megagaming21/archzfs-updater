#!/bin/bash

# To Do - Add logic to automatically downgrade the linux version if necessary
# https://wiki.archlinux.org/title/Arch_Linux_Archive
# pacman -U https://archive.archlinux.org/packages/path/packagename.pkg.tar.zst
# or https://github.com/archlinux-downgrade/downgrade

# Add the archzfs signing key
pacman-key --init
pacman-key --recv-keys 3A9917BF0DED5C13F69AC68FABEC0A1208037BE9
pacman-key --lsign-key 3A9917BF0DED5C13F69AC68FABEC0A1208037BE9

# Set the download directory
archive_dir="/mnt/zfs/pkg"

# Set the filenames
original_db="$archive_dir/archzfs.db"
compressed_db="$archive_dir/database.db.xz"
decompressed_db="$archive_dir/database.db"

# Check if the file was de-compressed successfully, if so then get the package versions from the database file.
if [ -f "$decompressed_db" ]; then
    # Get the linux version
    packagename=zfs-linux-lts
    linux_version=$(tar -xO --wildcards -f "$decompressed_db" "$packagename"*/desc | grep -m 1 linux-lts=)
    linux_version="${linux_version/linux-lts=/}"

    # Get the zfs version
    zfs_version=$(tar -xO --wildcards -f "$decompressed_db" "$packagename"*/desc | grep -m 1 zfs-utils=)
    zfs_version="${zfs_version/zfs-utils=/}"

    # Get zfs-linux-lts version
    zfs_linux_lts=$(tar -tf "$decompressed_db" | grep -m 1 zfs-linux-lts)
    zfs_linux_lts="${zfs_linux_lts///}"

    # Get zfs-linux-lts-headers version
    zfs_linux_lts_headers=$(tar -tf "$decompressed_db" | grep -m 1 zfs-linux-lts-headers)
    zfs_linux_lts_headers="${zfs_linux_lts_headers///}"

    # Get zfs-utils version
    zfs_utils_version=$(tar -tf "$decompressed_db" | grep -m 1 zfs-utils)
    zfs_utils_version="${zfs_utils_version///}"

    # Display the variables
    echo
    echo linux_version = $linux_version
    echo zfs_version = $zfs_version
    echo
    echo zfs_linux_lts = $zfs_linux_lts
    echo zfs_linux_lts_headers = $zfs_linux_lts_headers
    echo zfs_utils_version = $zfs_utils_version
    echo

    # Construct the exact filename to install
    # example - linux-lts-6.12.35-1-x86_64.pkg.tar.zst

    down_linux_lts="linux-lts-$linux_version-x86_64.pkg.tar.zst"
    down_linux_lts_sig="linux-lts-$linux_version-x86_64.pkg.tar.zst.sig"

    down_linux_lts_headers="linux-lts-headers-$linux_version-x86_64.pkg.tar.zst"
    down_linux_lts_headers_sig="linux-headers-lts-$linux_version-x86_64.pkg.tar.zst.sig"

    down_zfs_linux_lts="$zfs_linux_lts-x86_64.pkg.tar.zst"
    down_zfs_linux_lts_sig="$zfs_linux_lts-x86_64.pkg.tar.zst.sig"
    down_zfs_linux_lts_headers="$zfs_linux_lts_headers-x86_64.pkg.tar.zst"
    down_zfs_linux_lts_header_sig="$zfs_linux_lts_headers-x86_64.pkg.tar.zst.sig"
    down_zfs_utils="$zfs_utils_version-x86_64.pkg.tar.zst"
    down_zfs_utils_sig="$zfs_utils_version-x86_64.pkg.tar.zst.sig"

    # Store the filenames into a list variable
    filenames=(
    $archive_dir/$down_linux_lts
    $archive_dir/$down_linux_lts_headers
    $archive_dir/$down_zfs_linux_lts
    $archive_dir/$down_zfs_linux_lts_headers
    $archive_dir/$down_zfs_utils
    )

    # Install the packages
    echo pacman --noconfirm -U "${filenames[@]}"
    pacman --noconfirm -U "${filenames[@]}"

# Skip the script and display an error if the database file is missing.
else
  echo "Failed to find $decompressed_db"
fi
