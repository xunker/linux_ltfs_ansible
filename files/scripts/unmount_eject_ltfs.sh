sudo umount {{ltfs_mount_point}}
sudo mt -f {{st_device}} rewind
sudo mt -f {{st_device}} eject
