#!/bin/bash
db_username=${db_username}
db_user_password=${db_user_password}
db_name=${db_name}
db_RDS=${db_endpoint}

yum update -y

yum install -y httpd
yum install -y mysql

amazon-linux-extras enable php7.4
yum clean metadata
yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}
systemctl start  httpd

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_user_password/g" wp-config.php
sed -i "s/localhost/$db_RDS/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php
define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '128M');
EOF

chown -R ec2-user:apache /var/www/html
chmod -R 774 /var/www/html

sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

systemctl enable  httpd.service
systemctl restart httpd.service
echo WordPress Installed