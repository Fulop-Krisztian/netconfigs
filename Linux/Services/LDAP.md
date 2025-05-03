# An overview of LDAP and its concepts 

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

![DIT structure overview](../../-%20Attachments/LDAP/DIT%20structure%20overview.png)

- Data is represented as a hierarchy of objects. These are called **entries (1)**.
- Each entry can have one or more **objectClasses (2)**. The objectclasses can have zero or more **attributes (3)**
- **Attributes (3)** have a name, contain data, and and is a member of one or more **objectClasses (2)**
- **ObjectClasses (2)** define what **attributes (3)** an object *can* have or *must* have.
- The resulting hierarchy of objects is called the **Directory Information Tree** (DIT).
- Each object has one parent, and can have multiple descendants.
- Objects have distinguished names (DN) *(like: `cn=thing, ou=thingstore, dc=contoso, dc=com`)*

By this you can start to see that this is just hierarchical database. Anything else you need LDAP to do comes from interacting with this database in a predefined way. The database structure is enforced by the server, and clients just interact with it.

For example, if you want to get the name of someone from Microsoft Active Directory, you would look at the user object of that someone, and by the standards of Microsoft Active Directory, you will find their name under the `sAMAccountName` attribute.

Configuration
---


Minimum working config examples:
---