import socket
import time

def _start_udp(addr):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(addr)
    while True:
        data = sock.recv(1024)
        print data

_start_udp(('127.0.0.1', 11514))
