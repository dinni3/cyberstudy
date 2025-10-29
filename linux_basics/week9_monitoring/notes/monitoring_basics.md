# Week 9 — System Monitoring & Log Analysis

## Overview
In this exercise, we explore Linux process and log monitoring commands commonly used during system administration and incident response.

## Objectives
- Use tools to view real-time system resource usage.
- Learn how to inspect logs for security and troubleshooting.
- Understand process management basics.

## Key Commands Summary

| Command | Purpose |
|----------|----------|
| ps aux | Show all running processes |
| top / htop | Monitor CPU/memory in real time |
| journalctl | View system logs (managed by systemd) |
| dmesg | View kernel logs |
| df / free | Disk and memory usage |
| ss -tuln | Check open listening ports |
| tail / grep | Inspect or filter logs |

## Insights
- `journalctl` is useful for investigating incidents (e.g., failed SSH logins).
- `dmesg` can reveal kernel or driver issues.
- Always use `sudo` when accessing system logs.
- `htop` is interactive and allows you to sort by CPU or memory easily.

## Artifacts
All outputs saved under:
- artifacts/ps_top15.txt
- artifacts/top_snapshot.txt
- artifacts/htop_snapshot.txt
- artifacts/journal_recent.txt
- artifacts/journal_ssh.txt
- artifacts/dmesg_tail.txt
- artifacts/auth_tail.txt
- artifacts/syslog_tail.txt
- artifacts/disk_usage.txt
- artifacts/memory_usage.txt
- artifacts/ss_tuln.txt

## Notes
This week demonstrates how system monitoring and logging are essential for both performance tuning and security auditing.
