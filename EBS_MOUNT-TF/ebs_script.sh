#!/bin/bash

# sudo su -

# for vol in xvdb xvdc xvdd xvde xvdf
# do
# fdisk /dev/${vol} <<EOF
# p
# n
# p
# 1
# 2048
# 16777215
# p
# w
# EOF
# done

# ##########Create Disk Labels
# pvcreate  /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

# ##########Create the Volume Group:
# vgcreate stack_vg /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1


# #########Check the newly created volume group:
# vgs

# #########Create the Logical Volumes (LUNS) with about 5G of space allocated initially

# for LUN in u01 u02 u03 u04 backup
# do
# lvcreate -L 5G -n Lv_${LUN} stack_vg

# #########Create ext4  filesystems on the logical volumes
# mkfs.ext4 /dev/stack_vg/Lv_${LUN}

# #########Create mount points that will hold the space for the logical volumes
# mkdir /${LUN}

# ######## Mount newly created disks
# mount /dev/stack_vg/Lv_${LUN} /${LUN}

# ############ Extend Lv_u01 by 3G by running below command:
# lvextend -L +3G /dev/mapper/stack_vg-Lv_u01

# ############ Resize Lv_u01 to the new size:
# resize2fs /dev/mapper/stack_vg-Lv_u01

# ########## Create a backup of your /etc/fstab file 
# sudo cp /etc/fstab /etc/fstab.orig

# ############3 Use the blkid command to find the UUID of the device.
# #sudo blkid

# ############ Open the /etc/fstab file using any text editor,
# #sudo vim /etc/fstab

# echo "/dev/stack_vg/Lv_${LUN}       /${LUN}    xfs    defaults,noatime    0    2" >> /etc/fstab

# ######## Mount all file systems in /etc/fstab
# sudo mount -a
# done

#EBS Mount
echo "Mounting EBS Volumes"

for vol in sdb sdc sdd sde sdf
do
sudo parted /dev/$vol mklabel gpt

parted /dev/$vol mkpart primary ext4 0% 100%
done

#Create physical volume
pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

#Create the Volume Group:
vgcreate stack_vg /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

#create the Logical Volumes (LUNS) with about 5G of space allocated initially:
for LUN in u01 u02 u03 u04 backups
do
lvcreate -L 5G -n Lv_$LUN stack_vg

#create est4 file system
mkfs.ext4 /dev/stack_vg/Lv_$LUN

mkdir /$LUN

mount /dev/stack_vg/Lv_$LUN /$LUN

lvextend -L +3G /dev/mapper/stack_vg-Lv_$LUN

resize2fs /dev/mapper/stack_vg-Lv_$LUN

# echo "/dev/stack_vg/Lv_$LUN    /$LUN    ext4    defaults,noatime   0   2" >> /etc/fstab

echo "/dev/stack_vg/Lv_$LUN    /$LUN    ext4    defaults,noatime   0   2" | sudo tee -a /etc/fstab

mount -a
done