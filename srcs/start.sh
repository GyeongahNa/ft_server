#!/bin/bash
/usr/sbin/service nginx start
/usr/sbin/service php7.2-fpm start
#/usr/sbin/service mysql start
while true; do sleep 1d; done

