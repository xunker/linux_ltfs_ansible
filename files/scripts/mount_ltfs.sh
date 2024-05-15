TAPE_APPLICATION_NAME=$(sg_read_attr {{sg_device}} -f 0x0801 | awk '{ print $3}')
if [ $TAPE_APPLICATION_NAME == "LTFS" ]; then
  echo "Mounting LTFS tape in {{sg_device}}"
  ltfs -o devname={{sg_device}} {{ltfs_mount_point}}
else
  echo "Tape in {{sg_device}} is not LTFS-formatted or not present."
  echo "('Application Name' returned from sg_read_attr was '${TAPE_APPLICATION_NAME}')"
fi
