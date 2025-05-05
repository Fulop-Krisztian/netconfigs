Requirements:

- Internet connection
- Admin privileges (usually right click > run as administrator)

# Quick method (Untested, but should work):

**run in cmd:**

```powershell
irm https://get.activated.win | iex
```
# Tested method:

Editing the registry:
---

First, open regedit: `Windows + R` → _run:_ **regedit**

**in regedit navigate to**  
  
`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\svsvc`

set → Start = 4

Next, right click on the  
`svsvc` folder → new key →
- name: `KMS`
- click on the `KMS` folder you created, and modify the default string → Value data: `kms_4`

It should look like this:

![[../- Attachments/Windows registry activation/KMS_4 key setting.png]]
##### optional step for finding your windows edition

**in `regedit` navigate to:**

`Computer\HKEY_CURRENT_USER\Control Panel\Desktop`

Set → PaintDektopVersion = 4

When you are done, you can [Remove the version number from desktop](#Remove%20the%20version%20number%20from%20desktop) if you don't like it.

Activating in Command Prompt (run as admin):
---
Open Command Prompt (or powershell) as administrator, and apply the `regedit` changes you made:
1. Search for `cmd` in the search menu,
2. right click `cmd`
3. run as administrator (this is important)
4. run `gpupdate /force` to apply the changes you made in `regedit`

> [!NOTE]  
> _You will now need to get a KMS key for your system (methods below). Windows 10 and 11 keys are usually, interchangeable. However, **you will need to get the edition of your windows installation right (home, pro, ultimate, etc…).**_
> 
> _(If you don’t know what edition you have, use the [optional regedit option](#optional%20step%20for%20finding%20your%20windows%20edition), and you will see it in the bottom right of your desktop)_

> [!TIP]
> **The most common Key**
> Windows 10/11 pro: `W269N-WFGWX-YVC9B-4J6C9-T83GX`

You can find more keys here (for different versions and editions):  

[https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys](https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys)

or even more here:  
  
[https://github.com/MicrosoftDocs/windowsserverdocs/blob/main/WindowsServerDocs/get-started/kms-client-activation-keys.md](https://github.com/MicrosoftDocs/windowsserverdocs/blob/main/WindowsServerDocs/get-started/kms-client-activation-keys.md)


**In cmd (still as admin):**  

```powershell
`slmgr /ipk <key>`
```

It should look something like this:

![[../- Attachments/Windows registry activation/Successful key install.png]]

If it’s unsuccessful, try other keys.

Next we will activate the key with a key activation server. For example:

```powershell
slmgr /skms kms8.msguides.com
```  

> [!IMPORTANT]  
If the server is offline, you can find and try more from here: [https://gist.github.com/Zibri/69d55039e5354100d2f8a053cbe64c5a](https://gist.github.com/Zibri/69d55039e5354100d2f8a053cbe64c5a))

The final step is to activate the key:
```powershell
slmgr /ato
```

If the activation was successful, it should look something like this:

![[../- Attachments/Windows registry activation/Successful key activation.png]]

##### Remove the version number from desktop

This is only for if you used this option to check you Windows version

**regedit:**  
  
`Computer\HKEY_CURRENT_USER\Control Panel\Desktop` PaintDektopVersion = 0

**CMD**:  
  
`gpupdate /force`