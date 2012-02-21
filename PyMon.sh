#!/bin/sh
while true ; do ./port_forwarder.py 127.0.0.1:1514:tcp 127.0.0.1:1515:tcp >>port_forwarder.log 2>&1 ; done
