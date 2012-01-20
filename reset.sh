#!/bin/sh

ls ./etc/config | egrep -v "README.txt" | xargs -I{} rm -rf ./etc/config/{}
ls ./etc/service | egrep -v "mongodb|webserver" | xargs -I{} rm -rf ./etc/service/{}
ls ./var/log/service | egrep -v "boot|nginx|mongodb|webserver" | xargs -I{} rm -rf ./var/log/service/{}
rm -rf ./storage/mongodb/*
