# Week 6 – Networking & Processes

Focus: monitor active network connections, view open ports, manage and inspect processes.
Artifacts saved in `linux_basics/week6_network_processes/artifacts/`.

## Commands Overview

**Networking**
- `ip a` → view all interfaces and IPs.  
- `ss -tulpn`, `netstat` → list open ports and listening services.  
- `ping`, `dig`, `traceroute` → connectivity and DNS checks.  

**Processes**
- `ps aux`, `top`, `kill` → monitor and manage processes.  
- `journalctl`, `dmesg` → read logs and kernel messages.

## Key Observations
- `ss` output shows which processes are listening on which ports.  
- `ps aux` helps identify high CPU or memory usage processes.  
- `journalctl` allows viewing system logs for troubleshooting.

## Artifacts
All command outputs stored in `linux_basics/week6_network_processes/artifacts/`.
