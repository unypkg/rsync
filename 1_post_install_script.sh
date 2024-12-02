#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091,SC2154

current_dir="$(pwd)"
unypkg_script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
unypkg_root_dir="$(cd -- "$unypkg_script_dir"/.. &>/dev/null && pwd)"

cd "$unypkg_root_dir" || exit

#############################################################################################
### Start of script

groupadd -r rsyncd
useradd -c "rsyncd Daemon User" -d /var/rsync -g rsyncd \
    -s /bin/false -r rsyncd

mkdir -pv /etc/uny/rsync

if [ ! -f /etc/uny/rsync/rsyncd.conf ]; then
    cat >/etc/uny/rsync/rsyncd.conf <<"EOF"
# This is a basic rsync configuration file
# It exports a single module without user authentication.

motd file = /var/rsync/welcome
use chroot = yes

[localhost]
    path = /var/rsync
    comment = Default rsync module
    read only = yes
    list = yes
    uid = rsyncd
    gid = rsyncd

EOF
fi

if [ ! -d /var/rsync ]; then
    install -v -dm 755 -o postfix -g postfix /var/rsync
fi

#############################################################################################
### End of script

cd "$current_dir" || exit
