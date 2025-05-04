---
title: Daemonizing things with systemd services
tags:
  - automation
  - linux
  - script
  - todo
---
Terminology, general knowledge
---

- Daemonizing lets you start, stop, enable, disable, and just generally manage services with Systemd.
- You can specify when the daemonized services should come up when booting
- You can also specify a lot of other things, which are not covered here.
- The things you write are called [[units]]. They have multiple kinds (like `service` or [[socket]]). Only services are covered here.

Prerequisites
---
- You init system is Systemd
- Root permissions

Sources
---


Configuration
---
```ini
[Unit]
Description=Quartz Builder
After=network.target

[Service]
ExecStart=/usr/bin/npx -- quartz build --watch
WorkingDirectory=/var/www/html/quartz
Restart=always
User=krissssz
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target

```


Minimum working config examples:
---