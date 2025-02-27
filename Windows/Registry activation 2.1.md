Requirements:

- Internet connection
- Admin privileges (you can run things as administrator)


### Quick method (Untested, but should work):

**run in cmd:**

`irm` `[https://get.activated.win](https://get.activated.win)` `| iex`

  

### Tested method:

First, open regedit: `Windows + R` → _run:_ **regedit**

**(optional for finding your windows edition) in regedit navigate to**  
  
`Computer\HKEY_CURRENT_USER\Control Panel\Desktop`, and set → PaintDektopVersion = 4

**in regedit navigate to**  
  
`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\svsvc`, and set → Start = 4  
Next, right click on the  
`svsvc` folder → new key →

- folder name: `KMS`
- click on the `KMS` folder you created, and modify the default string → Value data: `kms_4`

It should look like this:

![[../- Attachments/Windows registry activation/KMS_4 key setting.png]]

  

## **in CMD (Command Prompt) (run as admin):**

run `gpupdate /force` to apply the changes you made in regedit (run as admin if it doesn’t work)

  

_You will now need to get a KMS key for your system (methods below). Windows 10 and 11 keys are usually, interchangeable. However, **you will need to get the edition of your windows installation right (home, pro, ultimate, etc…).**_

_(If you don’t know what edition you have, use the optional regedit option, and you will see it in the bottom right of your desktop)_

**The most common Key**:  
windows 10 pro: _W269N-WFGWX-YVC9B-4J6C9-T83GX_

or you can find more keys here (for different versions and editions):  
  
[https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys](https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys)

or even more here:  
  
[https://github.com/MicrosoftDocs/windowsserverdocs/blob/main/WindowsServerDocs/get-started/kms-client-activation-keys.md](https://github.com/MicrosoftDocs/windowsserverdocs/blob/main/WindowsServerDocs/get-started/kms-client-activation-keys.md)

  

**CMD (still as admin):**  
  
`slmgr /ipk <key>`

It should look something like this:

![[../- Attachments/Windows registry activation/Successful key install.png]]

If it’s unsuccessful, try other keys.

  
  
`slmgr /skms kms8.msguides.com` (if it is offline, you can find and try more from here: [https://gist.github.com/Zibri/69d55039e5354100d2f8a053cbe64c5a](https://gist.github.com/Zibri/69d55039e5354100d2f8a053cbe64c5a))

  
  
`slmgr /ato`

It should look something like this:

![[../- Attachments/Windows registry activation/Successful key activation.png]]

  

If you don’t want the version number on the bottom:

**regedit:**  
  
`Computer\HKEY_CURRENT_USER\Control Panel\Desktop` PaintDektopVersion = 0

**CMD**:  
  
`gpupdate /force`