---
title: AWS EC2 (Virtual machines)
tags:
  - cloud
  - virtualization
  - aws
---
Terminology, general knowledge
---
- EC2 stands for Elastic Compute 2

Configuration
---

#### Web server

This was designed for the default Amazon Linux image

> [!NOTE]  
> You need to paste these into the **User data - *optional*** section somewhere near the bottom of the EC2 setup page

```bash
#!/bin/bash
dnf install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><body><h1>It works!</h1></body></html>" > /var/www/html/index.html
```



