#!/bin/bash
sudo su -
yum update -y
yum install git -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

##Install the needed packages and enable the services(MariaDb, Apache)
yum install -y httpd mariadb-server
yum install -y nfs-utils
systemctl start httpd
systemctl enable httpd
systemctl is-enabled httpd

# FILE_SYSTEM_ID=${FILE_SYSTEM_ID}
# TOKEN=$(curl --request PUT "http://169.254.169.254/latest/api/token" --header "X-aws-ec2-metadata-token-ttl-seconds: 3600")
# REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region --header "X-aws-ec2-metadata-token: $TOKEN")
MOUNT_POINT=/var/www/html

#EFS CREATION AND MOUNTING
mkdir -p ${MOUNT_POINT}
chown ec2-user:ec2-user ${MOUNT_POINT}
echo ${FILE_SYSTEM_ID}.efs.${REGION}.amazonaws.com:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
mount -a -t nfs4
# 
 
 
##Add ec2-user to Apache group and grant permissions to /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd ${MOUNT_POINT}
chmod -R 755 ${MOUNT_POINT}
git clone ${GIT_REPO}
cp -r CliXX_Retail_Repository/* ${MOUNT_POINT}
 
#variable declaration 
WP_CONFIG=${MOUNT_POINT}/wp-config.php
RDS_INSTANCE=$(echo "${DB_HOST}" | sed 's/':3306'//g')
#Replacing DB Hostname in wp-config.php file to Correct 
sed -i "s/'wordpress-db.cc5iigzknvxd.us-east-1.rds.amazonaws.com'/'$${RDS_INSTANCE}'/g" $WP_CONFIG
 


## Allow wordpress to use Permalinks
# sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf
 
##Grant file ownership of /var/www & its contents to apache user
chown -R apache /var/www
 
##Grant group ownership of /var/www & contents to apache group
chgrp -R apache /var/www
 
##Change directory permissions of /var/www & its subdir to add group write 
chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
 
##Recursively change file permission of /var/www & subdir to add group write perm
find /var/www -type f -exec sudo chmod 0664 {} \;
 
##Restart Apache
systemctl restart httpd
service httpd restart
 
##Enable httpd 
systemctl enable httpd 
/sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5

Configure database
mysql -h "$${RDS_INSTANCE}" -u "${DB_USER}" -p "${DB_PASSWORD}" "${DB_NAME}" <<EOF
UPDATE wp_options SET option_value = '${CLIXX_LB}' WHERE option_value LIKE '%Clixx%';
EOF