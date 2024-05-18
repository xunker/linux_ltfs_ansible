sudo umount "$LTFS_MOUNT"
sudo mt -f $TAPE rewind
sudo mt -f $TAPE eject
