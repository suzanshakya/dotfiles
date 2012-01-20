import socket
import time
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.connect(('127.0.0.1', 11514))

while True:
    data = sock.sendall('hi')
    time.sleep(1)
