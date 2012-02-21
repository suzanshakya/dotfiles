#!/usr/bin/env python
"""\
Usage: %prog <source_address> <destination_address>

Options:
source_address: IP:PORT
destination_address: IP:PORT:udp

Examples:
listens in both udp and tcp and forward to udp
%prog 192.168.2.3:514 192.168.2.4:514:udp

listens in udp and forwards in udp
%prog 192.168.2.3:514:udp 192.168.2.4:514:udp
"""

import re
import optparse
import socket
import threading
import Queue
import logging
import hashlib
from logging.handlers import RotatingFileHandler

new_line_appender_re = re.compile(r'(<\d+>.+?)([^ ]+)(?:(?=<\d+>)|$)')

def get_checksum(msg):
     h = hashlib.sha256()
     h.update(msg)
     return h.digest(), h.hexdigest()

def add_newline(data, client_ip):
    def msg_enhancer(matchobj):
        msg = matchobj.group(1)
        actual_checksum, actual_hex_checksum = get_checksum(msg)

        checksum = matchobj.group(2)
        hex_checksum = checksum.encode("hex_codec")
        is_checksum_ok = actual_checksum == checksum
        checksum_status = "ok" if is_checksum_ok else "fail"
        if not is_checksum_ok:
            logging.warning("invalid checksum for msg=%r; included_checksum=%r;\
                    actual_checksum=%r", msg, hex_checksum, actual_hex_checksum)
        new_data = "%s%s checksum=%s device_ip=%s\n" % (msg, hex_checksum, checksum_status, client_ip)
        return new_data
    return new_line_appender_re.sub(msg_enhancer, data)

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
        "tcp": socket.SOCK_STREAM,
        "udp": socket.SOCK_DGRAM,
    }
    sock = socket.socket(socket.AF_INET, socks[sock_type])
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    return sock


class Receiver(object):
    def __init__(self, address):
        self.q = Queue.Queue()
        self.addr, self.type_ = _get_addr_type(address)

    def start(self):
        socks = {
            "tcp": [self._start_tcp],
            "udp": [self._start_udp],
            None: [self._start_tcp, self._start_udp],
        }
        targets = socks[self.type_]
        for target in targets:
            threading.Thread(target=target, args=(self.addr,)).start()

    def _start_tcp(self, addr):
        sock = _create_socket("tcp")
        sock.bind(addr)
        sock.listen(1)
        while True:
            conn, client_addr = sock.accept()
            logging.info("tcp connection from %r", client_addr)
            while True:
                data = conn.recv(1024)
                if not data:
                    break
                logging.info("received data from %r in tcp mode: %r", client_addr, data)
                self._put(data, client_addr)

    def _start_udp(self, addr):
        sock = _create_socket("udp")
        sock.bind(addr)
        while True:
            data, client_addr = sock.recvfrom(1024)
            logging.info("received data from %r in udp mode: %r", client_addr, data)
            self._put(data, client_addr)

    def _put(self, data, client_addr):
        data = add_newline(data, client_addr[0])
        self.q.put(data)

class Sender():
    def __init__(self, address, q):
        self.addr, self.type_ = _get_addr_type(address)
        self.q = q

    def start(self):
        threading.Thread(target=self._send_forever, args=()).start()

    def _get_socket(self, type_, addr):
        sock = _create_socket(type_)
        sock.connect(addr)
        return sock

    def _send_forever(self):
        data = None
        while True:
            if self.type_ is None:
                socks = map(self._get_socket, ("tcp", "udp"), (self.addr,)*2)
            else:
                socks = [self._get_socket(self.type_, self.addr)]

            if data:
                for sock in socks:
                    sock.sendall(data)

            try:
                while True:
                    data = self.q.get()
                    logging.info("sending msg: %r", data)
                    for sock in socks:
                        sock.sendall(data)
            except socket.error:
                pass

def forward(src, dst):
    logging.info("forwarding data from %r to %r", src, dst)

    receiver = Receiver(src)
    sender = Sender(dst, receiver.q)

    receiver.start()
    sender.start()

def main():
    logger = logging.getLogger()
    handler = RotatingFileHandler('port_forwarder.log', maxBytes=1<<20, backupCount=0)
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)

    parser = optparse.OptionParser(__doc__)
    options, args = parser.parse_args()
    try:
        src = args[0]
        dst = args[1]
    except IndexError, err:
        parser.error("syntax error")

    forward(src, dst)

main()
