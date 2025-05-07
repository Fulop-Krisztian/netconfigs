---
title: NGINX webserver
tags:
  - linux
  - webserver
  - service
  - todo
---
Terminology, general knowledge
---
- Very similar to Apache. The configuration files are different are different in format, but very similar in logic.
- Faster than Apache, scales much better (especially in Non-SSL applications)

Prerequisites
---
- Root privileges
- NGINX is installed (`sudo apt install nginx`)

Sources
---


Configuration
---

#### Managing sites

 > [!NOTE]  
> NGINX doesn't have a utility to manage sites ([As opposed to Apache](Apache.md#Managing%20sites)), but the way they handle site enabling in the background is completely the same:
> An available site's configuration file (located in `/etc/nginx/sites-available/` by convention) is soft-linked to the `/etc/nginx/sites-available/enabled-sites/` folder.

> [!IMPORTANT]  
> You need to reload NGINX after the configuration.
> `sudo systemctl reload nginx`
##### To enable a site

```bash
sudo ln -s /etc/nginx/sites-available/<site.conf> /etc/nginx/sites-enabled/
```
##### Disable site

```bash
sudo rm /etc/nginx/sites-enabled/<site.conf>
```

##### List enabled sites:

```bash
ls /etc/nginx/sites-available
```



Working config examples:
---