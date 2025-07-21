#!/bin/bash

# Requires wget, xz, tar

# Set the download storage directory
#archive_dir="/var/cache/pacman/pkg"
archive_dir="/mnt/zfs/pkg"





# Caution! Changing anything below could break the script.

# archzfs database filenames
original_db="$archive_dir/archzfs.db" # The original .db file to download, the script cannot use it because it is compressed.
compressed_db="$archive_dir/database.db.xz" # Copy/rename the .db file to a compressed filename extension.
decompressed_db="$archive_dir/database.db" # De-compressed .db file

# The archzfs download URL and archzfs.db file
base_url="https://github.com/archzfs/archzfs/releases/download/experimental/"
filenames=(
  "archzfs.db"
)

# Create the download directory if it doesn't exist
mkdir -p "$archive_dir"

clear

# Download the files
for filename in "${filenames[@]}"; do
  url="$base_url$filename"
  wget -q -O "$archive_dir/$filename" "$url"

  # Check if the file was downloaded successfully
  if [ -f "$original_db" ]; then
    echo "Downloaded $filename to $archive_dir"

    # Rename the database
    echo "Copied $original_db to $decompressed_db.xz"
    cp "$original_db" "$decompressed_db.xz"

    # de-compress the database
    xz -d -f "$decompressed_db.xz"

  # Show error if the file did not download.
  else
    echo "Failed to download $filename"
  fi
done

# Allow the filesystem to update with the latest download.
wait
sync
sleep 3

# Check if the file was de-compressed successfully, if so then get the package versions from the database file.
if [ -f "$decompressed_db" ]; then
  echo "De-compressed $decompressed_db.xz to $decompressed_db"
  echo
  echo "Getting package versions from $decompressed_db"

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

  # Construct the exact filename to download
  down_zfs_linux_lts="$zfs_linux_lts-x86_64.pkg.tar.zst"
  down_zfs_linux_lts_sig="$zfs_linux_lts-x86_64.pkg.tar.zst.sig"
  down_zfs_linux_lts_headers="$zfs_linux_lts_headers-x86_64.pkg.tar.zst"
  down_zfs_linux_lts_header_sig="$zfs_linux_lts_headers-x86_64.pkg.tar.zst.sig"
  down_zfs_utils="$zfs_utils_version-x86_64.pkg.tar.zst"
  down_zfs_utils_sig="$zfs_utils_version-x86_64.pkg.tar.zst.sig"

  # Store the filenames into a list variable
  filenames=(
  $down_zfs_linux_lts
  $down_zfs_linux_lts_sig
  $down_zfs_linux_lts_headers
  $down_zfs_linux_lts_header_sig
  $down_zfs_utils
  $down_zfs_utils_sig
  )

  # Download the files in the filenames list
  for filename in "${filenames[@]}"; do
    url="$base_url$filename"
    wget -q -O "$archive_dir/$filename" "$url"

    # Check if the file was downloaded successfully
    if [ -f "$archive_dir/$filename" ]; then
      echo "Downloaded $filename to $archive_dir"
    else
      echo "Failed to download $filename"
    fi
  done

# Skip the script and display an error if the database file is missing.
else
  echo "Failed to find $decompressed_db"
fi
