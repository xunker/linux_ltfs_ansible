PATH="$PATH:{{ltfs_scripts_location}}" # mount_ltfs.sh and unmount_eject_ltfs.sh

# Add ltfs_scripts_location to PATH only if it's not already there.
# Source: https://superuser.com/a/39995
if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
fi

export LTFS_MOUNT="{{ltfs_mount_point}}"

LSSCSI_TAPE=$(lsscsi -g | grep tape )
export ST_DEVICE=$(echo $LSSCSI_TAPE | tr ' ' "\n" | grep 'dev/st')
export NST_DEVICE=$(echo $ST_DEVICE | sed -E "s/\/(st)/\/nst/") # /dev/st0 => /dev/nst0
export TAPE=$NST_DEVICE
export SG_DEVICE=$(echo $LSSCSI_TAPE | tr ' ' "\n" | grep 'dev/sg')

# Or, can use this to get the /dev/sg? device from ltfs device list, along with
# serial number:
#
# LTFS_DEVICE_INFO=$(
#   ltfs -o device_list |
#   tail -n 1 |
#   awk -F ',' '{ for (i = 1; i <= NF; i++) {print $i }; printf "\n"}' |
#   awk '{$1=$1; print}'
# )
# export SG_DEVICE=$(echo $LTFS_DEVICE_INFO | grep 'Device Name' | cut -d ' ' -f4)
# export TAPE_SN=$(echo $LTFS_DEVICE_INFO | grep 'Serial Number' | cut -d ' ' -f4)
