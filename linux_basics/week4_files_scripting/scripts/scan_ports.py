#!/usr/bin/env python3
import socket, csv, sys, time

targets = ['127.0.0.1']
ports = [22, 80, 443, 3000, 8080]
outfile = '../artifacts/port_scan.csv'

with open(outfile, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['timestamp','target','port','open'])
    for t in targets:
        for p in ports:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(0.8)
            try:
                s.connect((t,p))
                open_flag = True
            except Exception:
                open_flag = False
            finally:
                s.close()
            writer.writerow([time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), t, p, open_flag])
print('Saved:', outfile)
