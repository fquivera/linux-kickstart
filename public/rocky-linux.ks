#version=RHEL9

# Use text install
text

# Create new user
user --name=fmovil --shell=/bin/bash --homedir=/home/fmovil  --iscrypted --password=$6$XC2VUhqSUdSWaWzf$YBA7x/d8t95SKyscRPXW7glWXxdX3HoNmtORsg1Bb62BQOuoF10Ssg5hOt3Cy3/3/fvFswG4LzkWE5/Ae8d63.

# Create new repo
repo --name="AppStream" --baseurl=file:///run/install/repo/AppStream

repo --name="Minimal" --baseurl=file:///run/install/sources/mount-0000-cdrom/Minimal

# Use CDROM installation media
cdrom

# Use NFS server for installation
# nfs --server=10.10.10.12 --dir=/images/

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network --bootproto=static --device=enp0s3 --ip=192.168.1.3 --netmask=255.255.255.0 --gateway=192.168.1.1 --nameserver=192.168.1.1 --onboot=yes --noipv6 --activate
#network  --bootproto=dhcp  --device=enp0s3 --noipv6 --activate
network  --hostname=fmovil.fuerzamovil.app

# Root password
rootpw --iscrypted $6$XC2VUhqSUdSWaWzf$YBA7x/d8t95SKyscRPXW7glWXxdX3HoNmtORsg1Bb62BQOuoF10Ssg5hOt3Cy3/3/fvFswG4LzkWE5/Ae8d63.

# Run the Setup Agent on first boot
firstboot --enable

# Do not configure the X Window System
skipx

# System services
services --enabled="chronyd"
selinux --disabled
firewall --disabled


# System timezone
timezone America/Caracas

# Reboot the node post installation
reboot

# Partition clearing information
clearpart --all
ignoredisk --only-use=sda

# Disk partitioning information
part /boot --size=1024 --asprimary --fstype=ext4 --ondrive=sda
part pv.1 --size 1 --grow --fstype="lvmpv" --ondrive=sda
volgroup rootvg --pesize=32768 pv.1

logvol swap --vgname rootvg --recommended --name=swap
logvol /var --fstype ext4 --vgname rootvg --size=8192 --name=var
logvol /opt --fstype ext4 --vgname rootvg --size=10240 --name=opt
logvol /opt/zimbra/backup --fstype ext4 --vgname rootvg --size=10240 --name=zbackup
logvol /opt/zimbra/hsm --fstype ext4 --vgname rootvg --size=5120 --name=zhsm
logvol / --fstype ext4 --vgname rootvg --size=1 --grow --name=root


# List of packages to be installed
%packages
@^server-product-environment
kexec-tools

%end


# Add on
%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

# Password Policy
%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
