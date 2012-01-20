import socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

sock.bind(('127.0.0.1', 12514))
sock.listen(1)

conn, addr = sock.accept()
conn.close()
sock.close()
