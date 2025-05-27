---
title: Active Directory
tags: []
---

Terminology, general knowledge
---


Prerequisites
---


Sources
---
[LDAP](../Linux/Services/LDAP.md)



Powershell commands
---
#### [Powershell AD install and configure](Powershell%20AD%20install%20and%20configure.md)

#### Create AD user

```powershell
New-ADUser -Name "John Doe" -SamAccountName "jdoe" -EmailAddress "jdoe@example.com" -Path "OU=Users,DC=example,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true
```
#### Create AD group

```powershell
New-ADGroup -Name "YourGroupName" -GroupScope Global -GroupCategory Security -Description "Description of the group"
```
Minimum working config examples:
---