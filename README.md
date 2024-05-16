ansible-playbook playbook.yaml --become-password-file sudo.txt
ansible-playbook playbook.yaml --ask-become-pass
ansible-playbook playbook.yaml --ask-pass --ask-become-pass

ansible-playbook playbook.yaml --extra-vars "configure_rtc=true configure_sdio=true configure_spi_ethernet=true"

(was "ansible-playbook -i inventory.yaml playbook.yaml")
(was "ansible-playbook --ssh-common-args '-o UserKnownHostsFile=/dev/null -o
StrictHostKeyChecking=no' -i inventory.yaml playbook.yaml")

# Credit

https://github.com/reduardo7/bash-service-manager and https://github.com/reduardo7/bashx

# TODO

add .keep file to /mnt/ltfs when created

disable suspend at login screen
https://unix.stackexchange.com/questions/361214/disable-gdm-suspend-on-lock-screen

use config file
https://github.com/LinearTapeFileSystem/ltfs/blob/master/docs/ltfs.conf.example

Check that target is Fedora/Redhat/yum/dnf before even trying to run

Allow for installation on non-redhat/non-yum/non-dnf distros
