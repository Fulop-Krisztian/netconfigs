# Rsyslog

Terminology, general knowledge
---
- It is for transferring log messages over an IP network.
- It can use databases to store the messages, for example MySQL
- `systemd-journald`might replace it in the future, but not in full. Right now (Debian 12, Bookworm) it conflicts a bit with it `journald` on Debian based systems, so you must configure it if you install it.

Prerequisites
---


Sources
---
https://wiki.debian.org/Rsyslog
https://wiki.archlinux.org/title/Rsyslog
Configuration
---


Minimum working config examples:
---