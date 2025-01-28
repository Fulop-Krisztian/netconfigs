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
![[Pasted image 20250125115508.png]]
