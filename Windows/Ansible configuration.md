# Windows configuration for automation with Ansible
#automation #ansible
Terminology, general knowledge
---
- Ansible uses WinRM with Windows (Other methods exist, but we will only cover this one), as opposed to the usual SSH
- Ansible is a powerful tool for automating, but it requires some configuration for Windows
- There is a lot of Authentication methods that you can (and should) use in production

Prerequisites
---
- A Linux host with Ansible installed
- A Windows (Server) host
- Static or otherwise known IPs (for inventory configuration)

Sources
---
[Ansible 101: For the Windows SysAdmin by Josh King](https://www.youtube.com/watch?v=SqO2HkKep90)

[Configure remoting for Ansible](https://github.com/AlbanAndrieu/ansible-windows/blob/master/files/ConfigureRemotingForAnsible.ps1)

Configuration
---
First, you should create a user. You should give this user the permission you expect you will need to automate. This is only for security.

The following script creates an user named `Ansible` with Administrator privileges. This is not recommended in production 
```powershell
$securePassword = ConvertTo-SecureString -String "Password123" -AsPlainText -Force
New-LocalUser -Name Ansible -Password $securePassword -PasswordNeverExpires -AccountNeverExpires
Add-LocalGroupMember -Group Administrators -Member Ansible

.\ConfigureRemotingForAnsible.ps1
```
>[!IMPORTANT]
>This script also tries to run [.\ConfigureRemotingForAnsible.ps1](Scripts/ConfigureRemotingForAnsible.ps1) requires 







Minimum working config examples:
--- 