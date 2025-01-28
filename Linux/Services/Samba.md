```
# Install Samba packages
sudo apt install samba samba-common-bin -y
```

This configuration is very locked down. Overwrite the default, but back the default up just in case
```
[global]
    # Network settings
    workgroup = HOME
    # Change realm to server domain
    realm = home.arpa
    netbios name = happycloud
    server string = ZFS Archive Server
    dns proxy = no
    
    # Security settings
    security = user
    map to guest = bad user
    server signing = auto
    client signing = auto
    
    # Logging
    log level = 1
    log file = /var/log/samba/%m.log
    max log size = 1000
    
    # Performance optimization
    socket options = TCP_NODELAY IPTOS_LOWDELAY
    read raw = yes
    write raw = yes
    use sendfile = yes
    min receivefile size = 16384
    aio read size = 16384
    aio write size = 16384
    
    # Multichannel support
    server multi channel support = yes
    
    # Disable unused services
    load printers = no
    printing = bsd
    printcap name = /dev/null
    disable spoolss = yes
    
    # Character/Unix settings
    unix charset = UTF-8
    dos charset = CP932

[archive]
    comment = ZFS Archive Share
    // Change this path
    path = /mediapool/archive
    valid users = louis
    invalid users = root
    browseable = yes
    read only = no
    writable = yes
    create mask = 0644
    force create mode = 0644
    directory mask = 0755
    force directory mode = 0755
    force user = louis
    force group = louis
    veto files = /._*/.DS_Store/.Thumbs.db/.Trashes/
    delete veto files = yes
    follow symlinks = yes
    wide links = no
    ea support = yes
    inherit acls = yes
    hide unreadable = yes
    guest ok = yes
```

#### Verify valid config:
```
testparm
```

#### After this, you need to give your user a samba password, to do this:

```
sudo smbpasswd -a <user>
sudo smbpasswd -e <user>
```

#### Start and Enable Samba
```
# Restart Samba services
sudo systemctl restart smbd
sudo systemctl restart nmbd

# Enable them to start at boot
sudo systemctl enable smbd
sudo systemctl enable nmbd
```