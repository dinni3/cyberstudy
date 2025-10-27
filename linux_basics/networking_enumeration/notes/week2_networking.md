# Week 2 – Networking & Enumeration

## 1. Basic Networking Commands
- `ip a`: Show network interfaces and IPs
- `ifconfig`: Legacy tool to view interface info
- `netstat -tuln` / `ss -tuln`: List open ports

## 2. DNS & Host Discovery
- `ping google.com` → test connectivity
- `dig openai.com` → DNS info
- `host github.com` → simple hostname lookup
- `nmap -sn 192.168.1.0/24` → discover live hosts

## 3. Service Enumeration
- `nmap -sV <target>` → detect service versions
- `nmap -p- <target>` → full port scan

## 4. Banner Grabbing
- `nc -v <target> 80` → get HTTP banner
- `curl -I <target>` → get server headers

## 5. Network Troubleshooting
- `ping`, `traceroute`, `curl`, `telnet` for connectivity checks

Artifacts stored in `artifacts/` folder.
