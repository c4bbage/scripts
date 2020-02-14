#!/usr/bin/env python

import sys
from scapy.all import PcapReader, re, Raw, TCP


VALID_METHODS = [
    "GET",
    "HEAD",
    "POST",
    "PUT",
    "DELETE",
    "CONNECT",
    "OPTIONS",
    "TRACE",
    "PATCH"
]  # see https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
HOSTNAME_BLACK = ['myqcloud.com']


def payload2curl(p):
    lines = re.compile("[\n\r]+").split(p.decode('utf-8'))
    start_line = re.search("^([A-Z]+) ([^ ]+) (HTTP\/[0-9\/]+)", lines[0])
    method = start_line.group(1)
    url = start_line.group(2)
    version = start_line.group(3)  # Never used

    if method not in VALID_METHODS:
        return

    del lines[0]
    headers = []
    for line in lines:
        if ":" in line:
            headers.append("-H '{}'".format(line.encode('utf-8')))
        if "Host:" in line:
            host_header = re.search("^Host:(.*)", line)
            host_name = host_header.group(1)
    for b in HOSTNAME_BLACK:
        if b in host_name.lower():
            return
    proto_host = 'http://{}/'.format(host_name.strip())
    if not url.startswith(proto_host):
        url = "{}{}".format(proto_host, url[1:] if url[0] == "/" else url)
    curl = "curl '{}' \\\n -X {} \\\n ".format(url, method)
    curl += " \\\n ".join(headers)
    return curl


def main():
    # if len(sys.argv) != 2:
    #     print ("I need an input file. Usage ./pcap2curl.py inputfilename")
    #     return

    infile = "52.pcap"

    with PcapReader(infile) as packets:
        for p in packets:
            if p.haslayer(TCP) and p.haslayer(Raw) and p[TCP].dport == 3458:
                payload = p[Raw].load
                cmd = payload2curl(payload)
                if cmd:
                    print(cmd)


if __name__ == "__main__":
    main()