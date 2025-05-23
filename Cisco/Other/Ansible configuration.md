---
title: Ansible configuration on/for Cisco devices
tags:
  - linux
  - cisco
  - ansible
  - etc
  - automation
---
Terminology, general knowledge
---
- Cisco devices use SSH for their Ansible connection
- You need a serial to set up at least the:
	1. Network connection
	2. SSH

Prerequisites
---
- The device you want to manage is reachable from the Ansible control node over the network.

Sources
---
[Ansible Cisco IOS configuration](https://docs.ansible.com/ansible/latest/collections/cisco/ios/index.html)

[Penguin WIki Ansible section](https://wiki.penguin.hu/en/ansible/setup)

Preparing devices
---

You need to configure SSH on the devices you intend to use Ansible for. For example:

```ios
hostname <hostname> 
ip domain name <domain>
username <user> secret <secret>
crypto key generate rsa general-keys modulus 2048
line vty 0 15
login local
transport input ssh
ip ssh version 2
```

Configuring Ansible
---

I recommend you place all of your Cisco devices in a group named Cisco and apply to them these group scoped variables:

```yaml
# === Cisco specific Ansible connection details ===
ansible_user: <user>

# For the passwords you should probably use Ansible vault
ansible_password: <password>
ansible_become_password: <enable_password>

# These are important
ansible_become_method: enable
ansible_network_os: ios
ansible_connection: network_cli

# You might need these options if the devices you are managing are old.
ansible_ssh_common_args: "-oKexAlgorithms=+diffie-hellman-group1-sha1 -oPubkeyAcceptedAlgorithms=+ssh-rsa -oHostkeyAlgorithms=+ssh-rsa -oCiphers=+aes128-cbc -o StrictHostKeyChecking=no"
```

If the device is reachable, you should now be able to run a basic task on it. For example:

```python
- name: Test reachability to 198.51.100.251 using default vrf
  cisco.ios.ios_ping:
    dest: 198.51.100.251
```

Some roles that might interest you:

[The Solar Dynamics Cisco configuration role, configuring all kinds of things](https://github.com/Horribili-kft/Ansible/tree/main/playbooks)

[Penguin Wiki roles, more focused on specific and advanced tasks](https://wiki.penguin.hu/en/ansible/playbooks)
