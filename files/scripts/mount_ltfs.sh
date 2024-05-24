TAPE_APPLICATION_NAME=$(sg_read_attr $SG_DEVICE -f 0x0801 | awk '{ print $3}')
if [ $TAPE_APPLICATION_NAME == "LTFS" ]; then
  echo "Mounting LTFS tape in $SG_DEVICE at $LTFS_MOUNT"
  ltfs -o nonempty -o devname=$SG_DEVICE "$LTFS_MOUNT"
else
  echo "Tape in $SG_DEVICE is not LTFS-formatted or not present."
  echo "('Application Name' returned from sg_read_attr was '${TAPE_APPLICATION_NAME}')"
fi
