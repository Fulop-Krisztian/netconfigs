---
title: Mail server with AD authentication
tags:
  - linux
  - windows
  - ldap
  - aaa
---
Terminology, general knowledge
---


Prerequisites
---


Sources
---


Configuration
---

#### Dovecot configuration for integration with AD

> [!NOTE]  
> You must create a user named mailbind in the AD. I gave it admin permissions, but you can get away without giving it any special permissions beyond just creating it.

##### /etc/dovecot/dovecot-ldap.conf.ext

```
# DNS name of the Windows server where the DC can be found
hosts = sd-hq-win1.solardynamics.eu

# The bind user configuration. You could put it in another OU or name it differently
dn = CN=mailbind,CN=Managed Service Accounts,DC=solardynamics,DC=eu
dnpass = Bindpass

base = DC=solardynamics,DC=eu

# We need to tell dovecot what variable to look at in AD to find the user. We use the sAMAccountName, which is what the name of the user is called in the AD LDAP structure.
user_filter = (&(objectClass=user)(sAMAccountName=%u))

# This is the same, but what to look for to authenticate the user against.
# The second part is what the user must type in to log into the mail service.
user_attrs = sAMAccountName=%u, =user=%u@mail.solardynamics.eu
```
##### /etc/dovecot/conf.d/10-auth.conf

```
disable_plaintext_auth = no
auth_mechanisms = plain login
!include auth-ldap.conf.ext
```

##### /etc/dovecot/conf.d/10-mail.conf

```
mail_location = maildir:/var/mail/virtual/%u%/Maildir
```
Minimum working config examples:
---