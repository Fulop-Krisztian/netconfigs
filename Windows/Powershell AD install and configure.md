# Active directory installation with Powershell

Terminology, general knowledge
---
 - These scripts are mostly meant for either: 
	- Quickly setting up a lab environment.
	- Taking snippets from the ad_env_setup to create your own scripts.

Prerequisites
---
- Basic knowledge about Active Directory
- Know what your AD domain is going to be. 

Sources
---

[AD installation script](Windows/Scripts/adinstall.ps1)
---
[adinstall.ps1](Windows/Scripts/adinstall.ps1)
The script has a verbose description, but here's an overview:

> [!NOTE]
> This script installs active directory with arguments you give it. If you give no arguments, it installs with these default options:
> 
> Domain name: contoso.com
> AD Admin password: Password123
> Netbios name: CONTOSO

#### Running examples:

> [!TIP]
> You can also configure the default variables ni the script

Argumentless:
```powershell
# Installs with contoso.com, Password123, and CONTOSO NetBIOS
.\adinstall.ps1
```

With arguments:

> [!TIP]
> If you don't give the NetbiosName argument, it is inferred from the DomainName

```powershell
.\adinstall.ps1 -DomainName "example.com" -AdminPassword "P@ssw0rd!" -NetbiosName "EXAMPLE"
# Uses example.com, provided password, and EXAMPLE NetBIOS
```


[AD environment setup](Windows/Scripts/ad_env_setup.ps1)
---
[ad_env_setup.ps1](Windows/Scripts/ad_env_setup.ps1)
This script has a verbose description. You will find much more information about it than here. 
This script is mostly AI generated, and will probably be of not much use beyond creating a lab environment 
Here's an overview:

  This script creates:
    1. A top-level OU called "Company" under the domain root.
    2. Three sub-OUs under "Company":
         • Employees – for user accounts.
         • Workstations – for computer accounts.
         • SecurityGroups – for groups.
    3. Five sample groups in SecurityGroups.
    4. 15 sample user accounts in Employees (each with a home directory and a logon script).
    5. Allowed logon hours for each user are set to Monday–Friday from 08:00 to 18:00. 
    6. Users are added to the sample groups.
    7. 5 sample computer accounts in Workstations.
    8. Four dummy Group Policy Objects (GPOs) are created and linked to the Employees OU.
    9. A sample logon script is created in a NETLOGON folder.



Minimum working config examples:
---