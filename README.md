# LTFS on Linux - Ansible Deployment Script

This repo automates the installation of [Linux LTFS Reference
Implementation](https://github.com/LinearTapeFileSystem/ltfs) on to a Linux
target, set helpful environment variables, and installs useful utilities like HP
Library and Tape Tools (HPE LTT).

- [Supported Target Linux Distros](#supported-target-linux-distros)
- [What it'll do](#what-itll-do)
- [Running the script](#running-the-script)
- [Using LTFS once install script completes](#using-ltfs-once-install-script-completes)
- [Caveats](#caveats)
- [Who?](#who)
- [TODO](#todo)
- [Thanks](#thanks)

## Supported Target Linux Distros

Currently working and tested with __Fedora 40 *workstation*__ -- it might work
for the *server* version too, but I had too many DNS problems to test with it.

It will *probably* work with OpenSuSE Leap/Tumbleweed 15.5, and other
Redhat-related distros.

It *might* work with Debian-based distros, but HPE LTT will NOT be installed.

## What it'll do

* Clone and install [Linux LTFS Reference
  Implementation](https://github.com/LinearTapeFileSystem/ltfs)
  - Also [applies the
    patch](https://github.com/LinearTapeFileSystem/ltfs/issues/394#issuecomment-2082624342)
    necessary for building on recent Linuxes

* Adds [profile.d script](files/etc/profile.d/ltfs_device_variables.sh) to
  automatically detect the tape device names and place them in environment
  variables
  - `$ST_DEVICE` : auto-rewind mt device (ex: `/dev/st0`)
  - `$NST_DEVICE` : no-rewind mt device (ex: `/dev/nst0`)
  - `$TAPE` : default device that mt will use, set to _$NST_DEVICE_
  - `$SG_DEVICE` : the SCSI Generic (sg) device path (ex: `/dev/sg2`)

* Creates mount-point (default `/mnt/ltfs`)

* Adds scripts to automate mounting and un-mounting of LTFS tapes
  - [mount_ltfs.sh](files/scripts/mount_ltfs.sh)
  - [unmount_eject_ltfs.sh](files/scripts/unmount_eject_ltfs.sh)

* Installs packages useful or essential for tape drive work
  - `mt-st` : provides the essential 'mt' command
  - `mtx` : tape library control
  - `lsscsi`
  - `sg3_utils` : provides 'sg_read_attr' and 'sg_rmsn', among others
  - `iotop` : quick-and-dirty way to track throughput on FC or SAS HBAs
  - `sysstat` : provides 'sar', 'sadf', 'mpstat', 'iostat', 'tapestat',
    'pidstat', 'cifsiostat', 'sa'

* Disables automatic suspend while on the GUI Login page for Fedora Workstation

* Downloads and installs HP Library and Tape Tools (`hpe_ltt`)
  - creates necessary compatibility symlinks, too
  - only runs on DNF/YUM distros like Redhat/Fedora, Centos, OpenSuSE, etc

## Running the script

1. Stand up a basic Linux box using the appropriate distro
    * Ensure that SSH is enabled and that you can log in as your preferred user
    * Ensure preferred user has `sudo` privileges

2. Install Ansible on your _local_ machine (i.e. *not* the linux box you just
   built)
   * For MacOS, homebrew is recommended: `brew install ansible`
   * For Linux, [see specific
     instructions](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)
   * For Windows and all others, see [Install
     Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

3. Get this code to your local machine using either of these:
  * Download a zip: https://github.com/xunker/linux_ltfs_ansible/archive/refs/heads/main.zip
  * Clone the repo: `git clone https://github.com/xunker/linux_ltfs_ansible.git`

4. Change any appropriate settings in the "vars:" section of `playbook.yaml`

5. Copy or rename `inventory.yaml.example` to `inventory.yaml` and make any
   appropriate changes
    * If the username on your linux box is different than local username,
      uncomment the "ansible_user" line  and add replace "USERNAME" with the
      correct username
    * You'll probably only need to change the hostname on the _ansible_host_
      line.

6. Run Ansible: `ansible-playbook playbook.yaml --ask-pass --ask-become-pass`
    * If you log in with an SSH public key, omit `--ask-pass`
    * If your user has sudo access without a password, omit `--ask-become-pass`

#### Skipping the sudo password prompt

If you're running this often and don't want to type in a sudo password every
time, create a file named `sudo.txt` and put the sudo password in that, then add
`--become-password-file sudo.txt` to your Ansible command above.

Remember: _never_ commit sudo.txt to your repo, ever.

#### Notice about SSH known_hosts

By default, this Ansible script will neither check nor record the SSH host keys
of the linux machine (see "ansible_ssh_common_args" in
`inventory.yaml.example`). To remove this behaviour, comment out the
"ansible_ssh_common_args" line.

## Using LTFS once install script completes

### Verify Environment Variables

First, check that the environment variables are correctly set by running `env |
grep -e 'DEVICE' -e 'TAPE' -e 'LTFS'`. It should return a list similar this,
though the paths may vary on your particular machine:

```bash
SG_DEVICE=/dev/sg4
NST_DEVICE=/dev/nst0
ST_DEVICE=/dev/st0
LTFS_MOUNT=/mnt/ltfs
TAPE=/dev/nst0
```
If you do not see at least those four lines, then something might be wrong with
the installation.

You can also verify the environment variables using `sudo mt status`. If it
returns an error like "The default '/dev/tape' is not a character device" then
there is also a problem with the environment variables. It it returns any other
error, or no error at all, your environment variables are probably _correct_.

### Format a tape as LTFS (optional)

If you do not already have a tape in LTFS format, insert it in to the drive and
run as root (or sudo):

```bash
# First get the current barcode of the tape, because mklts will erase it
$ BARCODE=$(sg_read_attr $SG_DEVICE | grep Barcode | awk '{ print $2}')

# Do the actual formatting. We truncate Barcode because mkltfs only allows it to be 6 characters long
$ mkltfs -d $SG_DEVICE -s $(echo $BARCODE | cut -n1-6)

# This last step is optional, and sets the Barcode in the tape attributes back to the original value if original was longer than 6 characters
$ sg_write_attr $SG_DEVICE 0x806=$BARCODE
```

### Mount an LTFS tape

There is an included script to make mounting LTFS tapes easier: [`mount_ltfs.sh`](files/scripts/mount_ltfs.sh).

Run that command as root (or sudo) and it will mount the LTFS tape in the
"ltfs_mount_point" in playbook.yaml (default "/mnt/ltfs").

The LTFS mount point is also available as `$LTFS_MOUNT`.

#### Possible Errors
If there is no tape inserted, or if the tape is not LTFS-formatted, this error
will be returned:
```
Tape in /dev/sg4 is not LTFS-formatted or not present.
('Application Name' returned from sg_read_attr was '')
```

### Unmounting and ejecting an LTFS tape

You can use the included `unmount_eject_ltfs.sh` script to eject a tape. It will
unmount the drive, rewind the tape, and eject it.

You can also do it manually as any mounted device:

```
umount /mnt/ltfs && mt rewind && mt eject
```

## Caveats

### No automount

LTFS is still a *tape*, so there is no automounting[^1].

[^1]: No automounting _yet_, but I've got some ideas.

### Multiple tape drives

All the added environment variables assume there is only one tape drive on your
system. LTFS will still build and install with multiple drives present, but the
environment variables may be set incorrectly.

### FC/SAS HBA configuration

This script will __not__ configure your Fibre Channel (FC) or
Serial-Attached-SCSI (SAS) Host Bus Adapter (HBA, or "card") for you. It expects
your HBA will be working *before* running this script.

You can verify that your HBA is installed correctly by running `lspci -k` and
finding your card in the list returned. It should have at least two lines below
it: "Kernel driver in use" and "Kernel modules". If those two lines are not
present then chances are your card is not configured correctly.

You can also verify that your tape drives are being detected in linux by running
`lsscsi | grep tape`. Your drive needs to appear in that list.

### iSCSI/FCoE/FCIP/iFCP/E-I-E-I-O

Likewise, this script will __not__ configure your iSCSI, FCoE, FCIP, or iFCP
connection for you. How to do that is left as an exercise for the reader.

## Who?

[xunker](https://github.com/xunker) made this by standing on the shoulders of
[many other hard-working people](#thanks).

## TODO

* Test on on non-redhat/non-yum/non-dnf distros
* Anything that calls `sg_read_attr` (or any sg3-utils command) will need to run *twice* before giving up. That's because with in a newly-inserted tape the first call can still return `Read attribute command: Unit attention` `sg_read_attr failed: Unit attention` on the first call but succeed on the second

## Thanks

The [Linux LTFS Team](https://github.com/LinearTapeFileSystem)

[TulioLazarini](https://github.com/TulioLazarini) for making [the patch that is
required](https://github.com/LinearTapeFileSystem/ltfs/issues/394#issuecomment-2082624342)
to build LTFS on recent linux systems

[vk5tu](https://unix.stackexchange.com/users/100569/vk5tu)
for config to [disable suspend mode on the GDM login
page](https://unix.stackexchange.com/a/746767)

[Philipp Waller](https://stackoverflow.com/users/1872827/philipp-waller) for
info on [package managers in Ansible](https://stackoverflow.com/a/70650223)

[Gordon Davisson](https://superuser.com/users/7778/gordon-davisson) for the
[append-to-path snippet](https://superuser.com/a/39995) in
ltfs_device_variables.sh

[DataHoarder](https://reddit.com/r/datahoarder) subreddit
