# An overview of LDAP and its concepts 
created: 2025-03-07 08:42
tags: #linux #windows #aaa 

Sources
---
[This is pretty much required reading for understanding LDAP on anything more than a superficial level](https://www.zytrax.com/books/ldap/)

Terminology, general knowledge
---
- LDAP is pretty much a database API, that shadows away the operations of the database.
- Its big advantage is ***standardization***.
- The other big advantage is ***simple replication***
- You might want to use a real database for tasks that require:
	- The data to be same accross all replicated nodes on every read (LDAP might leave them unsynced for a few miliseconds after updates)
	- You have a lot of write and update traffic

### Object Tree Structure (the important part)

- Data is represented as a hierarchy of objects. These are called **entries (1)**.
- Each entry can have one or more **objectClasses (2)**. The objectclasses can have zero or more **attributes (3)**
- **Attributes (3)** have a name, contain data, and belong an is a member of one or more **objectClasses (2)**
- The resulting hierarchy of objects is called the **Directory Information Tree** (DIT).
- Each object has one parent, and can have multiple descendants.
![DIT structure overview](../../-%20Attachments/LDAP/DIT%20structure%20overview.png)
- Objects have distinguished names (DN) *(like: cn=thing, ou=thingstore, dc=contoso, dc=com)*

Configuration
---


Minimum working config examples:
---