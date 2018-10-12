#!/bin/bash
mongod --dbpath=/home/mongo &
source /etc/apache2/envvars && exec apache2 -D FOREGROUND
