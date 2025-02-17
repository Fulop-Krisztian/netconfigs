This is a special format document in this repository.
It contains a few Linux commands that you may find useful for some purpose, or is otherwise just interesting.

Be careful about running them.


Check failed SSH tries
---
With this command you can check how many failed authentication attempts there were, trying to SSH into your system. If your port is exposed to the internet, you will get an insane number, since there's someone trying to SSH into your system pretty much every (few) second(s).
> [!NOTE]
> It may take a few minutes to run this command if you have a lot of log SSH log entries

```bash
journalctl --no-pager -xu ssh.service | grep 'authentication failure' | wc -l
```
Output of running the command on my exposed system: (~77 days of data, with some skips in uptime on a dynamic residential IP), resulting in a fail count of 534056, or half a million failed logins. This is about 7000 login tries each day, or 290 each hour.
![Public SSH command output.png](../Misc/Pictures/Public%20SSH%20command%20output.png)


Resilient disk image/copy over SSH
---
With this command you can image a whole disk with `dd` and output the file over SSH to a different machine. The `dd` command also has some other switches (`conv=noerror,sync`), which make it ignore errors by copying zeroes in place of unreadable data, keeping the alignment of the disk

```bash
sudo dd conv=noerror,sync if=/dev/sda bs=4M | ssh user@<your-pc-ip> "dd of=~/diskimage.img"
```

I use it to occasionally make a full image backup of my raspberry pi.