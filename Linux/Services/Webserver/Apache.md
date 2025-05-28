---
title: Apache HTTP Server Project
tags:
  - linux
  - webserver
  - service
---
Terminology, general knowledge
---
- The "Apache HTTP Server Project" is known by many names, and it's kind of confusing what name you should use (Wikipedia [has a whole section](https://en.wikipedia.org/wiki/Apache_HTTP_Server#Name) explaining its name these include:
	- **Apache HTTP Server**: It's official name.
	- **`httpd`**: This is the process name when it's running in Linux.
	- **`apache`** or **`apache2`**: These are the names you will use in the terminal probably (Apache is also the name of the foundation that made the webserver, try not to get confused, because it is confusing) 
	- This document will refer to it as Apache
- A barebones webserver pretty much only has one job: Give the requested file to the requester (client).
- Apache does a bunch of other things by default using (including) **modules**, for example:
	- **Autoindexing**: Automatically creating webpages to browse directories
	- **Authentication**: You can use basic web authentication (It's outdated and not really used anymore
	- **Caching**: Some basic caching
	- And a lot of other defualt modules, some of which you may want to disable to make the server more secure.
- **SSL is not included by default**
- Distributions like to customize Apache to an extent that you may not be used to with other packages, so don't be surprised.

Prerequisites
---
- Root privileges
- Apache is installed (`sudo apt install apache2`)

Sources
---
- [Arch wiki](https://wiki.archlinux.org/title/Apache_HTTP_Server)
- [Debian wiki](https://wiki.debian.org/Apache)

Working config examples:
---
You have to [create](#Creating%20a%20site) and [enable](#Enable%20site) the sites for them to work, even if not specified. If other things are required, they are mentioned. [Modules](#Modules) are assumed to be in default state.
#### `example.com.conf`: Redirect

```xml
<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com

    # Redirect all HTTP to HTTPS
    Redirect permanent / https://example.com/

    ErrorLog ${APACHE_LOG_DIR}/example.com-error.log
    CustomLog ${APACHE_LOG_DIR}/example.com-access.log combined
</VirtualHost>
```

#### `example.com-ssl.conf`:  SSL + Aliases + Basic Auth + Location Options

```xml
<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName example.com
    ServerAlias www.example.com

    DocumentRoot /var/www/example.com/public_html

    SSLEngine on
    SSLCertificateFile      /etc/ssl/certs/example.crt
    SSLCertificateKeyFile   /etc/ssl/private/example.key

    <Directory /var/www/example.com>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    # Example: /assets points to a different location
    Alias /assets /var/www/example.com/assets
    <Directory /var/www/example.com/assets>
        Options -Indexes +FollowSymLinks
        Require all granted
    </Directory>

    # Example: stricter location for /admin, with authentication
    <Location "/admin">
        AuthType Basic
        AuthName "Restricted Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user

        # Extra location-specific config
        Options -Indexes
    </Location>

    ErrorLog ${APACHE_LOG_DIR}/example.com-ssl-error.log
    CustomLog ${APACHE_LOG_DIR}/example.com-ssl-access.log combined
</VirtualHost>
</IfModule>
```

```bash
sudo a2enmod ssl
sudo a2ensite example.com-ssl.conf
sudo systemctl reload apache2
```

#### `usersite.local.conf` – UserDir support

> [!NOTE]  
> If you enable the userdir module, something similar to this should be included automatically (the config file is usually under `/etc/apache2/mods-enabled/userdir.conf`)

> [!TIP]
> If you get `403 Forbidden`, then try the `Require all granted` option

```xml
<VirtualHost *:80>
    ServerName usersite.local

    # Enable UserDir (requires mod_userdir)
    UserDir public_html

    <Directory /home/*/public_html>
        AllowOverride None
        Options +Indexes -ExecCGI
        Require all granted
    </Directory>

    # Minor option: custom default index
    DirectoryIndex index.html index.htm index.php

    ErrorLog ${APACHE_LOG_DIR}/usersite-error.log
    CustomLog ${APACHE_LOG_DIR}/usersite-access.log combined
</VirtualHost>
```

Configuration
---
### Sites (virtual hosts)

Apache serves sites using configuration files called **virtual hosts**. In this section I will sometimes refer to them as sites.

Site configurations are stored in **`/etc/apache2/sites-available/`** and are managed with `a2...site` tool, similar to modules

#### Creating a site

> [!NOTE]  
> When changing site configurations, reloading is enough.
> `sudo systemctl reload apache2`

You should copy the default config to make it easier. Name the copy properly
```bash
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/<your_site>.conf
sudo nano /etc/apache2/sites-available/<your_site>.conf
```
You can configure a LOT of things here. Most important are:
- `<VirtualHost <ip>:<port>>`: You can specify on what ports and what IPs the site should listen to. You can use wildcards, and that is the default for IPs.
- `DocumentRoot`: You specify the path to the files of the webserver.
- `ServerName`: You can run multiple sites on the same server with this, and Apache will serve the site that matches the `ServerName` the user has searched for. For example, if `site1.thing.com` and `site2.thing.com` both resolve to the same IP (so the same server), apache will server a different depending on if it was reached by using site1.thing.com, or `site2.thing.com`. If it's not specified for a site, that site become the default  (if there's no other site with a ServerName to match the user's request to serve)

Next step is to [enable the site](#Enable%20site)

#### Managing sites

##### Enable site

```bash
sudo a2ensite <site_configuration_name>
```

##### Disable site

```bash
sudo a2dismod <module_name>
```

> [!TIP]
> Enabling a site pretty much just creates a soft-link to the site configuration file in the `/etc/apache2/sites-enabled` directory. This is the same behavior as [NGINX](NGINX.md)

##### List enabled sites

```bash
ls /etc/apache2/sites-enabled/
```

### Modules

#### Managing modules

I recommend managing modules with the `a2...mod` tool, below are the most often used commands

> [!IMPORTANT]  
> For module changes, you ***should restart*** apache, ***don't just reload*** it.
> 
> `systemctl restart apache2`
> 
> (Some modules support just a reload to enable/disable them, but restart always works)

##### Check enabled modules

```bash
sudo apache2ctl -M
```

##### Enable module

```bash
sudo a2enmod <module_name>
```

##### Disable module

```bash
sudo a2dismod <module_name>
```


#### Module recommendations

Modules (mods for short) are an important part of Apache. They pretty much make Apache functional, there are a bunch of default modules, and I recommend keeping *most* of them on.

There are some mods that can be turned off however. The following settings are all applicable to a simple HTTP/HTTPS server you might use. 

##### Must-disable
The mods that I would for sure [disable](#Disable%20module) on a production server are:
1. **`status`** (`mod_status`): Exposes server status information. Requires permissions by default, but it's just another point of failure.
2. **`info`** (`mod_info`): Similar to mod_status:, but exposes configuration details instead.
3. **`autoindex`** (`mod_autoindex`): You might not want this. It allows clients to find ALL files in a website's directory (they can't see other files on the server though, unless you configure that). By default they would have to find files using hyperlinks, or trial and error.
4. **`userdir`** (`mod_userdir`): This was popular back in the day: Every user would have their own website under the URL of `http://<fqdn>/~<username>`, which corresponds to the `/home/<username>/public_html` directory on the server. Security-wise it's not that dangerous, since users probably would not create a folder randomly named `public_html`, but every modules comes with a performance cost as well.
5. **`include`** (`mod_include`): If you're not using this, then turn this off. If you are using this, change your site so you're not using it. This enables XSS vulnerabilities. Don't rely on this for modern web development.

##### Maybe-disable
The mods that I would [disable](#Disable%20module) if I'm not using:
1. **`ldap`** (`mod_ldap`)
2. **`auth`** (`mod_auth_basic` and `mod_auth_digest`)
3. **`php`**, **`python`**, **`perl`** (`mod_php`, `mod_python`, `mod_perl`)
4. **`proxy`** (`mod_proxy`, `mod_proxy_http`, `mod_proxy_ftp`, `mod_proxy_connect`)
5. **`cgi`** (`mod_cgi`)

##### **Must enable** 
Mods that I could not use Apache without [enabling](#Enable%20module):
1. **`ssl`** (`mod_ssl`): Module for HTTPS/SSL/TLS support. You should use this for anything public facing if you don't want browsers to warn users with that your site is not secure, and that if they visit it, their computer will instantly get a virus, which drain their whole bank account and take the soul of their firstborn child.


