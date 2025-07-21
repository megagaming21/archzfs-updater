#!/bin/bash

# Test script to solve getting package version information from the database file.

# Set the download directory
archive_dir="/mnt/zfs/pkg"

# Set the filenames
original_db="$archive_dir/archzfs.db"
compressed_db="$archive_dir/database.db.xz"
decompressed_db="$archive_dir/database.db"

# Rename the database
cp "$original_db" "$compressed_db"

# de-compress the database
xz -d -f "$compressed_db"

# Get the linux version
packagename=zfs-linux-lts
linux_version=$(tar -xO --wildcards -f ./database.db "$packagename"*/desc | grep -m 1 linux-lts=)
linux_version="${linux_version/linux-lts=/}"

# Get the zfs version
zfs_version=$(tar -xO --wildcards -f ./database.db "$packagename"*/desc | grep -m 1 zfs-utils=)
zfs_version="${zfs_version/zfs-utils=/}"

# Get zfs-linux-lts version
zfs_linux_lts=$(tar -tf ./database.db | grep -m 1 zfs-linux-lts)
zfs_linux_lts="${zfs_linux_lts///}"

# Get zfs-linux-lts-headers version
zfs_linux_lts_headers=$(tar -tf ./database.db | grep -m 1 zfs-linux-lts-headers)
zfs_linux_lts_headers="${zfs_linux_lts_headers///}"

# Get zfs-utils version
zfs_utils_version=$(tar -tf ./database.db | grep -m 1 zfs-utils)
zfs_utils_version="${zfs_utils_version///}"

echo linux_version = $linux_version
echo zfs_version = $zfs_version
echo
echo zfs_linux_lts = $zfs_linux_lts
echo zfs_linux_lts_headers = $zfs_linux_lts_headers
echo zfs_utils_version = $zfs_utils_version
