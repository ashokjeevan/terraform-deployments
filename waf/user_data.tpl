#!/bin/bash
environment=${environment}
yum update -y

yum install -y httpd
systemctl start  httpd

systemctl enable  httpd.service
systemctl restart httpd.service
