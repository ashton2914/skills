---
name: Linux Server Management
description: Comprehensive skills for managing, monitoring, and troubleshooting Linux servers.
---

# Linux Server Management

This skill provides instructions, tools, and best practices for managing Linux servers. It covers system monitoring, user administration, package management, service control, and basic troubleshooting methodologies.

## Core Capabilities

1.  **System Monitoring & Resource Management**
    *   Monitor CPU, memory, Disk I/O, and network usage.
    *   Identify and manage resource-intensive processes.
    *   Check disk space and partition health.
2.  **Service & Daemon Control**
    *   Start, stop, restart, and check the status of systemd services.
    *   Enable services to start on boot.
    *   Analyze service logs for errors.
3.  **User & Access Management**
    *   Create, modify, and delete user accounts and groups.
    *   Manage SSH keys and configuration.
    *   Configure `sudo` privileges securely.
4.  **Package Management & Updates**
    *   Install, update, and remove software packages (APT/YUM/DNF).
    *   Manage repositories.
    *   Perform safe system upgrades.
5.  **Network Configuration & Troubleshooting**
    *   Check network interfaces, IP addresses, and routing tables.
    *   Test connectivity (ping, traceroute, telnet/nc).
    *   Monitor active connections and listening ports.
6.  **Log Analysis & Troubleshooting**
    *   Read and filter system logs (`/var/log/syslog`, `/var/log/messages`, `journalctl`).
    *   Investigate authentication failures, system crashes, and application errors.

## Standard Operating Procedures (SOPs)

### System Health Check Routine
When asked to perform a general health check on a server, follow these steps:
1.  **Uptime & Load:** Run `uptime` to check how long the system has been running and current load averages.
2.  **Memory:** Run `free -m` to check available RAM and swap space usage.
3.  **Disk Space:** Run `df -h` to check available space on all mounted filesystems. Pay special attention to `/` and `/var`.
4.  **Top Processes:** Run `top -b -n 1 | head -n 20` to see what is currently consuming CPU/Memory.
5.  **Critical Logs:** Check recent system logs using `journalctl -n 50 -p err` to quickly spot any recent errors.

### Troubleshooting an Unresponsive Service
If a specific service (e.g., Nginx, memory, MySQL) is reported as down or unresponsive:
1.  **Status Check:** Run `systemctl status <service_name>` to determine if systemd thinks the service is active, failed, or inactive.
2.  **Recent Logs:** If failed, immediately run `journalctl -u <service_name> -n 100 --no-pager` to read the specific error messages that caused the crash.
3.  **Configuration Test:** If the service is a web server or database with a syntax checking command (e.g., `nginx -t`, `apachectl configtest`), run it to rule out configuration errors.
4.  **Port Check:** If the service is running but unreachable, use `ss -tulpn | grep <expected_port>` to ensure it is actually binding to the correct interface and port.

## Essential Commands Reference

*   **Process Management:** `ps aux`, `top`, `htop`, `kill`, `killall`, `pkill`
*   **Disk & Filesystem:** `df -h`, `du -sh *`, `lsblk`, `fdisk -l`
*   **Networking:** `ip addr`, `ip route`, `ping`, `mtr`, `ss -tulpn`, `dig`, `curl -I`
*   **Logs & Systemd:** `systemctl`, `journalctl`, `tail -f /var/log/auth.log`
*   **System Information:** `uname -a`, `cat /etc/os-release`, `lscpu`, `free -m`

## Important Considerations
*   **Always read before writing:** Before making configuration changes, always cat/view the current configuration file.
*   **Backup before modifying:** If modifying a critical configuration file (like `/etc/ssh/sshd_config` or `/etc/fstab`), copy it to a `.bak` file first (e.g., `cp /etc/fstab /etc/fstab.bak`).
*   **Least Privilege:** Execute commands with regular user privileges unless `sudo` is strictly required. Only use `root` access when necessary.
