# Week 5 – Users, Groups & System Information

Focus: learn to manage users and groups, inspect processes, and view system info safely.

Artifacts saved in `linux_basics/week5_users_system/artifacts/`.

## Commands Overview

- **groupadd, useradd, usermod, userdel, groupdel** → manage users & groups.
- **id, getent, groups** → query user/group info.
- **uname, hostnamectl, uptime, df, free, top, lscpu** → system inspection.

## Key Observations
- `id devuser` shows UID, GID, and group membership.
- `df -h` confirms filesystem usage in human-readable format.
- `free -h` and `/proc/meminfo` show available and used memory.
- Cleanup ensures no leftover demo users/groups remain.

## Artifacts
All command outputs stored in `linux_basics/week5_users_system/artifacts/`.
