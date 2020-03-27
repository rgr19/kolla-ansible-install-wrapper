#!/usr/bin/env python3
import os
import re
import json
import time
from typing import Iterator

import tqdm
import subprocess
from pathlib import Path

# FIXME:
"""
Use static ip for slaves
ping them until they respond

================================================================
Notes:

arp -a is cached

Phase 1: get used IP and range

ip route get 1
1.0.0.0 via 192.168.8.1 dev eno1 src 192.168.8.156 uid 1001 
    cache 

Phase 2: scan for neighbors without cache
nmap -p 22 192.168.8.0/24 -oG -

Phase 3:
"""


def main(serversMacs: list):
    serversMacs: set = set(map(lambda x: tuple(x.split()), serversMacs))
    serversMacs: dict = {n: sm for n, sm in enumerate(serversMacs)}
    outerPbar = tqdm.tqdm(total=len(serversMacs), position=0, ascii=True)
    innerPbar = tqdm.tqdm(total=1000, position=1, ascii=True)
    outerPbar.set_description(desc=f"[INFO] Wait for [{len(serversMacs):*>4}] SERVERS")

    while serversMacs:
        idx, serverMacs = serversMacs.popitem()
        innerPbar.set_description(desc=f"[INFO] Try SERVER no [{idx:*>4}] with [{len(serverMacs):*>4}] MACS")
        innerPbar.update(1)
        if wait_for_mac(serverMacs):
            outerPbar.update(1)
            continue
        else:
            serversMacs[idx] = serverMacs
            time.sleep(1)


def extrac_ips(line):
    return re.findall(r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b", line)


def flush_cache(neighborsList):
    for line in neighborsList:
        for ip in extrac_ips(line):
            subprocess.check_output(f'arp -d {ip}'.split(), shell=True, stderr=subprocess.STDOUT)


def find_neighbors_cached() -> list:
    neighbors: str = subprocess.check_output('arp -n'.split(), timeout=3).decode('utf-8')
    return neighbors.strip().splitlines()


def find_neighbors() -> list:
    neighbors: list = find_neighbors_cached()
    flush_cache(neighbors)
    return find_neighbors_cached()


def wait_for_mac(serverMacs):
    neighbors = find_neighbors()
    for mac in serverMacs:
        matches = list(filter(lambda x: mac in x, neighbors))
        if matches:
            return True


if __name__ == '__main__':
    macsFilePath = f'data/macs/slaves'
    if os.path.exists(macsFilePath):
        serversMacs = open(macsFilePath).read().splitlines()
        main(serversMacs)
    else:
        raise ValueError("Macs file does not exist for slaves.")
