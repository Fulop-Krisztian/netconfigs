# Ansible usage on Linux

This guide will cover basic usage and structure of Ansible. You should look at online tutorials for more in-depth 
Terminology, general knowledge
---
- Ansible is a powerful tool for automation, you can automate a lot of different tasks, like pinging many different hosts, installing packages, copying files. Anything that you do manually can be done in Ansible
- Ansible is declarative, meaning you define what you want the system's state to be, not how to get there (You define that you want the host to have XYZ IP address, not how to configure XYZ IP address)
- Ansible by default operates on with Linux machines, but with plugins (pleaes don't be afraid to use plugins, they are why Ansible is so powerful), you can manage pretty much anything (i.e.: Windows or Cisco devices)
- Ansible uses a regular SSH connection by default (Some plugins use other things, like Windows [[Ansible configuration]])

Related files
---
[[Ansible configuration (Windows)]]
[[Ansible configuration]]
Prerequisites
---
- An Linux system with Ansible installed.

Sources
---
- [Ansible 101: For the Windows SysAdmin by Josh King](https://www.youtube.com/watch?v=SqO2HkKep90)
- [Network Programmability and Automation, 2nd Edition](https://www.oreilly.com/library/view/network-programmability-and/9781098110826/)
- Generative AI

Configuration
---


Minimum working config examples:
---