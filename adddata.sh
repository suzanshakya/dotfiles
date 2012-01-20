#!/bin/sh

while true ; do
#    result=`curl -k https://localhost/adddata 2>1`
    echo "adding data"
    result=`wget -q  -O- --no-check-certificate https://localhost/adddata`
    if test "$result" = "Data Added to Database" ; then
        echo "Data Added to Database"
        break
    else
        echo "sleeping"
        sleep 1
    fi
done
