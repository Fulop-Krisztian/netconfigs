# AWS Identity and Access Management

tags: #cloud #aaa #aws #basic 


Terminology, general knowledge
---
- One AWS account can have many users, and the account login itself is referred to as the root user.
![AWS account with multiple users and groups with policies](../../-%20Attachments/AWS/AWS%20account%20hierarchy.png)
- IAM Role means something similar to a User, but it can be assumed by anyone who needs to (Similar to [Proxmox](../../Linux/Proxmox/Proxmox.md) permissions if you are familiar with it). It is an AWS Identity with permission policies that determine their permissions. (It's a set of predetermined permissions)

### Configuration console location

> [!NOTE]  
> You can manage users by searching for IAM  and opening the IAM named service.

![How to find the IAM management dashboard](../../-%20Attachments/AWS/IAM%20console%20location.png)

This console is pretty self explanatory, you can manage the IAM object by clicking on them on the left of the page


### Users

You can configure for users what you would expect to be able to configure in a normal identity management environment, for exmple:
- Permissions (policies)
- Groups they are a member of
- Security credentials (passwords and auth methods)

You can also see some information about their usage of the platform

### Groups (User groups)

Groups give policies to users in bulk.

### Policies

Policies are a grouping of permissions
For example, AmazonEC2ReadOnlyAccess, which is a built in *Managed policy*.

![Picture of the AmazonEC2ReadOnlyAccess policy](../../-%20Attachments/AWS/Policy%20example.png)

It is the policy itself which contains the permissions, for example this policy contains:

![Permissions inside the AmazonEC2ReadOnlyAccess policy](../../-%20Attachments/AWS/Permissions%20of%20a%20policy.png)

You can also view these permissions in JSON form:

![Policy JSON form](../../-%20Attachments/AWS/JSON%20permission%20form.png)

The other type of policy is an *Inline policy*, which only belongs to a single object (Like a single group or a single user).

They should be usually used for temporary or one-off cases.