#!/bin/bash

lsb_distr=`lsb_release -i`;
lsb_distrRelease=`lsb_release -r`;
lsb_distr=${lsb_distr:16};
lsb_distrRelease=${lsb_distrRelease:9};
mountpoint=`lsblk -o MOUNTPOINT | grep MyDisk`;

dateTime=`bash -c "date '+%d.%m.%y-%H:%M:%S'"`
exList="${mountpoint}/Soft/OS/Linux/Backup-images/exclude_list"
backupRchive="${mountpoint}/Soft/OS/Linux/Backup-images/${lsb_distr}${lsb_distrRelease}${1}_${dateTime}.tar.gz"

echo "Команда: tar czf $backupRchive --exclude-from=$exList /";

bash -c "tar czf $backupRchive --exclude-from=$exList /"
