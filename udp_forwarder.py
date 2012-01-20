#!/usr/bin/env python
"""\
Usage: %prog <source_address> <destination_address>

Options:
source_address: IP:PORT
destination_address: IP:PORT

If IP is omitted, IP is set to "127.0.0.1"

Examples:
%prog 192.168.2.3:514 192.168.2.4:514
%prog 514 192.168.2.4:514\
"""

import re
import optparse
import socket
import threading
import Queue
import logging

new_line_appender_re = re.compile(r'<\d+>')

def add_newline(data):
    return new_line_appender_re.sub(r"\n\1", data)

def _get_addr_type(address):
    addr_info = address.split(":")
    try:
        addr = addr_info[0], int(addr_info[1])

        if len(addr_info) == 3:
            type_ = addr_info[2]
            assert type_ in ("udp", "tcp")
        else:
            type_ = None
    except:
        raise ValueError("Unsupported address: %r" % address)

    return addr, type_

def _create_socket(sock_type):
    socks = {
        "tcp": socket.SOCK_DGRAM,
        "ucp": socket.SOCK_STREAM,
    }
    sock = socket.socket(socket.AF_INET, socks[sock_type])
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    return sock

def _try_close_sockets(*socks):
    for sock in socks:
        try:
            sock.close()
        except:
            pass

class Receiver(object):
    def __init__(self, address):
        self.q = Queue.Queue()
        addr, type_ = _get_addr_type(address)

        if type_ is None:
            _create_threads("tcp", addr)
            _create_threads("udp", addr)
        else:
            _create_threads("udp", addr)

    def _create_threads(self, type_, addr):
        if type_ == "tcp":
            target = self._start_tcp
        elif type == "udp":
            target = self._start_udp

        threading.Thread(target=target, args=(addr,)).start()

    def _start_tcp(self, addr):
        sock = _create_socket("tcp")
        sock.bind(addr)
        sock.listen(1)
        conn, addr = sock.accept()
        self._recv_forever(conn)

    def _start_udp(self, addr):
        sock = _create_socket("udp")
        sock.bind(addr)
        self._recv_forever(sock)

    def _recv_forever(self, conn):
        while True:
            data = conn.recv()
            q.put(data)

class Sender(Receiver):
    def __init__(self, address, q):
        super(Sender, self).__init__(address)
        del self.q
        self.q = q

    def _start_tcp(self, addr):
        sock = _create_socket("tcp")
        sock.bind(addr)
        sock.listen(1)
        conn, addr = sock.accept()
        self._recv_forever(conn)

    def _start_udp(self, addr):
        sock = _create_socket("udp")
        sock.bind(addr)
        self._recv_forever(sock)

    def _send_forever(self, conn):
        while True:
            data = self.q
            q.put(data)


def udp_forward(src_addr, dst_addr):
    while True:
        src_sock = _create_socket(socket.SOCK_DGRAM)
        dst_sock = _create_socket(socket.SOCK_DGRAM)

        src_sock.bind(src_addr)
        dst_sock.connect(dst_addr)

        try:
            while True:
                data = src_sock.recv(1024)
                data = add_newline(data)
                dst_sock.sendall(data, dst_addr)

        except Exception, err:
            logging.warn("udp_forward: %r", err)
            _try_close_sockets(src_sock, dst_sock)

def tcp_forward(src_addr, dst_addr):
    while True:
        src_sock = _create_socket(socket.SOCK_STREAM)
        dst_sock = _create_socket(socket.SOCK_STREAM)

        src_sock.bind(src_addr)
        dst_sock.connect(dst_addr)

        src_sock.listen(1)
        conn, addr = src_sock.accept()
        logging.info("tcp connection from %r", addr)

        try:
            while True:
                data, addr = conn.recv(1024)
                data = add_newline(data)
                dst_sock.sendall(data)

        except Exception, err:
            logging.warn("tcp_forward: %r", err)
            _try_close_sockets(src_sock, dst_sock)


def forward(src_addr, dst_addr):
    logging.info("forwarding data from %r to %r (tcp, udp)", src_addr, dst_addr)

    #threading.Thread(target=udp_forward, name="udp_forwarder",
    #                 args=(src_addr, dst_addr)).start()
    tcp_forward(src_addr, dst_addr)

def main():
    logging.basicConfig(level=logging.INFO)
    parser = optparse.OptionParser(__doc__)
    options, args = parser.parse_args()
    try:
        src = args[0]
        dst = args[1]
        src_addr, dst_addr = map(split_ip_port, [src, dst])
    except IndexError, err:
        parser.error("syntax error")

    forward(src_addr, dst_addr)

main()
