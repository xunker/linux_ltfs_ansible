sudo umount {{ltfs_mount_point}}
sudo mt -f $TAPE rewind
sudo mt -f $TAPE eject
