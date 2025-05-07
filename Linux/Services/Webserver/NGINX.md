---
title: NGINX webserver/proxy
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


Webserver Configuration
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



Proxy configurations
---

> [!NOTE]  
> The following configurations are battle-tested, I use them every day to proxy services to my home network
#### Simple proxy config

This one is just a simple proxy for proxying pure HTTP connections. It's as simple as I would go

```nginx

server {
	listen 443;	
        server_name portainer.home.arpa;
        location / {
	        # proxy target
			proxy_pass https://192.168.1.200:9443/;
			# preserve the real client info
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
        }
}

```

#### Advanced configs

```nginx
server {
    server_name krissssz.ddns.net;
    
    gzip on; # Compression
    
	# Logs
	error_log /var/log/nginx/proxmox_error.log;
    access_log /var/log/nginx/proxmox_access.log combined;

    #----------------------- Webhook Proxying -------------------------
	# Proxying webhooks (To Linux Webhooks daemon in this case)
    location /hooks/ {
        proxy_pass         http://127.0.0.1:9000/hooks/;
        proxy_http_version 1.1;
        # preserve the real client info
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        # ensure large payloads don’t break. This is optional
        client_max_body_size 10M;
        # disable buffering so webhook sees payload ASAP. This is optional
        proxy_request_buffering off;
    }    

    #------------------- Advanced Webapp Proxying ----------------------
	# This one should work for proxying 90% of the Webapps you would want to proxy. You can use this for simpler sites as well.
	# (This config is tested and working for Proxmox Web UI, which has websockets and a bunch of other things, so it's solid)

	# Optional
	# You can't skip this if the page you're proxying requires websockets.
	# This is needed for websockets.
	map $http_upgrade $connection_upgrade {
	  default upgrade;
	  '' close;
	}

	# Optional
	# Defines a logical group of backend servers. Naming this upstream
	# "proxmox" allows us to refer to it elsewhere if we add multiple
	# nodes or load‑balance later. It's not used in this configuration
	upstream proxmox {
		# You have to have to enter this hostname in your /etc/hosts file
		# Otherwise you could just use and IP address (I think)
	    server pve; 
	}
	
    location / {
	    # You can proxy HTTPS, but this comes with a overhead that is noticable at scale
        proxy_pass https://10.0.0.1:8006$request_uri;
        # Do not rewrite redirects sent by Proxmox; keep paths intact
        proxy_redirect off;
        
        # Forward original headers for correct virtual-hosting behavior
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	
		# Support very long polls and uploads (e.g. console, backups)
        proxy_read_timeout 3600s;
        proxy_connect_timeout 3600s;
		proxy_send_timeout 3600s;
		send_timeout 3600s;
		
        # Attach WebSocket upgrade headers from our map above
        proxy_set_header Upgrade $http_upgrade;  # Allow the protocol to upgrade
        proxy_set_header Connection "upgrade";   # Maintain the upgrade header
 
		# Turn off response buffering to stream data directly
		proxy_buffering off;
		
        # Remove any client size limit for file transfers
		client_max_body_size 0;
	
    }

	# This is a custom error page. I set up contact information, and a dark theme there. 
	# 502 = invalid gateway, which is what you get when the service you are proxying can't be reached
    error_page 502 /502.html;
    location = /502.html {
        root /var/www/html/errors;
        internal;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/krissssz.ddns.net-0001/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/krissssz.ddns.net-0001/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot	
}

# This is just HTTP > HTTPS redirection
server {
    if ($host = krissssz.ddns.net) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
    listen 80;
    server_name krissssz.ddns.net;
    return 404; # managed by Certbot
}

# Yes I use certbot, how did you know?
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣤⣄⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣻⣿⣿⣿⣿⣿⣿⣿⠉⠉⠛⠛⠛⠛⠿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⡿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠲⠶⢤⡄⠀⠘⢿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡿⠁⣂⡀⠀⠀⠀⠀⠀⠦⠤⣽⠷⣾⢷⢮⣀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⡷⠟⠉⠀⠀⢀⣠⣶⣶⣶⣤⣠⣤⡟⠈⢻⡿⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠠⠼⠿⢻⣿⣻⣿⣿⣿⣿⣿⣷⣾⣣⣇⡀⢻⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⢿⡿⣿⣿⣿⠁⠀⠀⠀⠲⣶⣷⣿⣿⣿⣿⣿⣿⣿⠟⢻⣟⣿⣿⣿⣾⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠃⡼⣁⢀⣿⠁⠀⠀⠀⠀⠀⠉⠙⢿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⣿⣿⣭⣛⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡟⠻⡟⣿⣷⡆⠀⠀⠀⠀⠀⢀⣠⣬⣿⣿⣿⣿⡋⠀⠈⢻⣟⣿⣌⣻⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⢷⣤⢁⣿⡿⣿⣀⣀⢀⡀⣼⠿⠟⢋⣿⣿⣿⣯⢉⣓⣂⠈⣿⠙⣿⠉⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠡⣤⡷⣾⣿⠷⢻⣿⣷⣿⣿⡟⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⡟⣿⣼⣷⠀⣼⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢀⣿⠛⣷⣴⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠗⢿⣽⡏⣸⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢸⣿⣟⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡻⢶⣿⣏⣙⡋⢳⣦⣿⣵⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣽⣿⣿⡊⢹⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠉⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⡃⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠈⠹⠻⣿⣿⣿⣿⢟⣿⣿⣿⣿⣿⣿⣿⣿⡿⠇⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣤⠶⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⢀⣀⣤⡶⠖⠛⠛⠉⠉⣁⣤⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⣿⣿⡿⠉⠁⢸⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⢀⣤⣶⠿⠛⠉⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⠀⢰⣾⣿⡷⠀⠀⣾⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠟⠁⠀⠀⠃⢀⠈⠉⢁⣨⣭⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⡇⠀⣀⣿⣿⡏⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⡀⠀⠠⠆⠒⣿⣶⣾⣿⣿⣿⡿⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷⠀⣿⣿⡏⠀⢸⠁⠀⡙⠷⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⣿⣶⣦⣶⣿⣿⣿⣿⣿⣿⣿⣧⣥⣄⡀⠀⠀⠀⣄⣀⠀⠀⡀⠀⠀⠀⣿⣿⣿⢿⣿⢀⣴⡻⠀⠀⣧⠀⠀⠈⠛⠶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⣿⣿⣷⣄⠀⠀⠀⠈⠉⠉⠉⠉⠛⠛⠛⠛⠿⠿⠿⣿⣷⣶⣿⣄⠀⢰⣿⢻⣿⣸⣿⣾⠁⠁⠇⠀⢿⣷⡤⣄⣀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠈⠻⠿⣿⣧⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⣀⠀⠈⠉⠙⠿⠷⣿⣏⠀⣿⣿⣿⡇⠀⠈⡀⠀⠈⠻⣷⡈⠻⢿⣤⠀⠈⠻⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠉⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡋⠀⠉⠠⠀⠈⠻⣄⢹⣿⡟⢀⣀⡴⢿⣶⠒⠺⠟⠛⠂⠀⢻⡆⢰⣶⣬⣍⣉⠓⠶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⠀⠀⠂⠶⢤⣄⡙⠀⠻⠁⣾⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣾⣿⣿⡟⠋⠙⠓⠂⠙⠓⠒⠶⢤⣤⡀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠿⠶⠀⠈⠀⠒⠀⢺⣿⣷⣿⣙⡻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣷⣀⢤⡴⢄⠀⠀⠀⠀⠀⠀⠉⠳⠦⣄⠀⠀⠀
#⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⠀⠀⠘⣿⣿⡿⣿⡟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣯⣷⣘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀
#⠴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠳⣄⠀⢸⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻
#⠀⠀⠐⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠄⠀⠀⠙⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣹⣿⠷⣦⣁⠂⠀⠀⠀⠀⠀⠀
#⠤⠄⠀⠀⠀⣀⡀⢀⡀⠤⠀⠉⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣦⠈⠛⢷⣄⠀⠀⠀⠀⠀
#⠛⠀⠀⠀⠀⠀⠠⠄⢀⡀⢀⣤⢠⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⠿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣦⠀⠈⠙⠀⠀⠀⠀⠀
#⠀⠀⠀⣐⣂⣀⣀⠀⣶⣶⣾⢉⣴⢾⣿⣷⣤⣤⣤⣤⣠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⡄⢀⣀⠀⠄⠈⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣦⡀⣀⣀⣀⣀⠀⢀
```


Working config examples:
---