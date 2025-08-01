# Ansible usage on Linux

This guide will cover basic usage and structure of Ansible. You should look at online tutorials for more in-depth 
Terminology, general knowledge
---
- Ansible is a powerful tool for automation, you can automate a lot of different tasks, like pinging many different hosts, installing packages, copying files. Anything that you do manually can be done in Ansible
- Ansible is declarative, meaning you define what you want the system's state to be, not how to get there (You define that you want the host to have XYZ IP address, not how to configure XYZ IP address)
- Ansible by default operates on with Linux machines, but with plugins (pleaes don't be afraid to use plugins, they are why Ansible is so powerful), you can manage pretty much anything (i.e.: Windows or Cisco devices)
- Ansible uses a regular SSH connection by default (Some plugins use other things, like Windows [Ansible configuration](../../Cisco/Other/Ansible%20configuration.md))

Related files
---

[Ansible configuration for Windows](../../Windows/Ansible%20configuration.md)

[Ansible configuration for Cisco](../../Cisco/Other/Ansible%20configuration.md)

Prerequisites
---
- A Linux system with Ansible installed.

Sources
---
- [Ansible 101: For the Windows SysAdmin by Josh King](https://www.youtube.com/watch?v=SqO2HkKep90)
- [Network Programmability and Automation, 2nd Edition](https://www.oreilly.com/library/view/network-programmability-and/9781098110826/)
- https://github.com/Horribili-kft/Ansible

Installation
---
> [!NOTE]  
> Setting up an Ansible control node can be done in a multitude of ways.
> The simplest method that consistently works is setting up a Python Virtual environment on a Linux machine, where you can run Ansible from. The following script does that:

#### Ansible 







Minimum working config examples:
---