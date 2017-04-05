#!/bin/bash
apt-get install nginx pwgen -y
mkdir /var/www/html/child
pwgen 1024 > /var/www/html/child/random.txt
mkdir /var/www/html/child/grandchild
pwgen 2048 > /var/www/html/child/grandchild/random.txt