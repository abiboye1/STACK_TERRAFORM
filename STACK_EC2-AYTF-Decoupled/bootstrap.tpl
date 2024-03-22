#!/bin/bash

sudo su -
yum update -y
yum install git -y
# install LAMP stack using Amazon Linux extras
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server
yum install -y nfs-utils
# Start and enable Apache HTTP Server
systemctl start httpd
systemctl enable httpd
# Check if Apache HTTP server is enabled
systemctl is-enabled httpd

#check test page
usermod -a -G apache ec2-user
#checking the groups to verify addition of 'apache'
groups

#Set permissions and ownership for /var/www/ directory
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

#Install addition PHP stuff and restarting services
yum install php-mbstring -y
systemctl restart httpd
systemctl restart php-fpm

#EFS CREATION AND MOUNTING
mkdir -p ${MOUNT_POINT}
chown ec2-user:ec2-user ${MOUNT_POINT}
echo "${FILE_SYSTEM_ID}".efs.${REGION}.amazonaws.com:/ ${MOUNT_POINT}  nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
mount -a -t nfs4

###################
#EBS Mount
# echo "Mounting EBS Volumes"

# for vol in sdb sdc sdd sde sdf
# do
# sudo parted /dev/$vol mklabel gpt

# parted /dev/$vol mkpart primary ext4 0% 100%
# done

# #Create physical volume
# pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

# #Create the Volume Group:
# vgcreate stack_vg /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

# #create the Logical Volumes (LUNS) with about 5G of space allocated initially:
# for LUN in u01 u02 u03 u04 backups
# do

# lvcreate -L 5G -n Lv_$LUN stack_vg
# #create est4 file system
# mkfs.ext4 /dev/stack_vg/Lv_$LUN
# #########Create mount points that will hold the space for the logical volumes
# mkdir /$LUN
# ######## Mount newly created disks
# mount /dev/stack_vg/Lv_$LUN /$LUN
# ############ Extend Lv_u01 by 3G by running below command:
# lvextend -L +3G /dev/mapper/stack_vg-Lv_$LUN
# ############ Resize Lv_u01 to the new size:
# resize2fs /dev/mapper/stack_vg-Lv_$LUN

# # echo "/dev/stack_vg/Lv_$LUN    /$LUN    ext4    defaults,noatime   0   2" >> /etc/fstab
# echo "/dev/stack_vg/Lv_$LUN    /$LUN    ext4    defaults,noatime   0   2" | sudo tee -a /etc/fstab

# sudo mount -a
# done
###################################

#Installing git
cd ${MOUNT_POINT}
chmod -R 755 ${MOUNT_POINT}
yum install git -y
# mkdir installation
# cd installation
git clone ${GIT_REPO}
cp -rf MY_STACK_BLOGS/* ${MOUNT_POINT}


#Setting up  wordpress database and configuration
DB_NAME="wordpressdb"
DB_USER="admin"
DB_PASSWORD="W3lcome123"
RDS_INSTANCE="wordpress.cxa6ui6m6ilk.us-east-1.rds.amazonaws.com"

####
WP_CONFIG=${MOUNT_POINT}/wp-config.php
#Update wordpress config with db details
sudo sed -i "s/'database_name_here'/'$DB_NAME'/g" $WP_CONFIG
sudo sed -i "s/'username_here'/'$DB_USER'/g" $WP_CONFIG
sudo sed -i "s/'password_here'/'$DB_PASSWORD'/g" $WP_CONFIG
sudo sed -i "s/'rds_instance'/'$RDS_INSTANCE'/g" $WP_CONFIG

#####Modify Apache HTTP server config
sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf


#restart apache http server and enable services
systemctl restart httpd
systemctl enable httpd 
systemctl restart mariadb && sudo systemctl enable mariadb

##Grant file ownership of /var/www & its contents to apache user
chown -R apache /var/www
##Grant group ownership of /var/www & contents to apache group
chgrp -R apache /var/www

##Change directory permissions of /var/www & its subdir to add group write
chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;

##Recursively change file permission of /var/www & subdir to add group write perm
find /var/www -type f -exec sudo chmod 0664 {} \;

# Restart Apache to make sure all changes take effect
systemctl restart httpd

mysql -h "$${RDS_INSTANCE}" -u "${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" <<EOF
UPDATE wp_options SET option_value = '${BLOG_LB}' WHERE option_value LIKE '%http%';
EOF

# #!/bin/bash 
# # DB_NAME='wordpressdb'
# # DB_USER='admin'
# # DB_PASSWORD='W3lcome123'
# # RDS_INSTANCE='newretail.cxa6ui6m6ilk.us-east-1.rds.amazonaws.com'
# # DB_EMAIL="yomioye007@gmail.com"


# #Update the system packages
# sudo yum update -y
# # install LAMP stack using Amazon Linux extras
# sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
# sudo yum install -y httpd mariadb-server
# # Start and enable Apache HTTP Server
# sudo systemctl start httpd
# sudo systemctl enable httpd
# # Check if Apache HTTP server is enabled
# sudo systemctl is-enabled httpd
# #check test page
# sudo usermod -a -G apache ec2-user
# #checking the groups to verify addition of 'apache'
# groups
# #Set permissions and ownership for /var/www/ directory
# sudo chown -R ec2-user:apache /var/www
# sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
# find /var/www -type f -exec sudo chmod 0664 {} \;
# #Install addition PHP stuff and restarting services
# sudo yum install php-mbstring -y
# sudo systemctl restart httpd
# sudo systemctl restart php-fpm
# #Installing git
# cd /var/www/html
# sudo yum install git -y
# sudo mkdir installation
# cd installation
# sudo git clone https://github.com/abiboye1/MY_STACK_BLOGS.git
# cp -rf MY_STACK_BLOGS/* /var/www/html

# ####
# WP_CONFIG=/var/www/html/wp-config.php
# #Update wordpress config with db details
# sed -i "s/'database_name_here'/'$DB_NAME'/g" $WP_CONFIG
# sed -i "s/'username_here'/'$DB_USER'/g" $WP_CONFIG
# sed -i "s/'password_here'/'$DB_PASSWORD'/g" $WP_CONFIG
# sed -i "s/'rds_instance'/'$RDS_INSTANCE'/g" $WP_CONFIG
# #restart apache http server and enable services
# sudo systemctl restart httpd
# sudo systemctl enable httpd && sudo systemctl enable mariadb
# #sudo systemctl status of MySQL and apache HTTP server
# sudo systemctl status mariadb
# sudo systemctl status httpd
# # Restart Apache to make sure all changes take effect
# sudo systemctl restart httpd