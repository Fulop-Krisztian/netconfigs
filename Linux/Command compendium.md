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
![Public SSH command output.png](../-%20Attachments/Public%20SSH%20command%20output.png)


Resilient disk image/copy over SSH
---
With this command you can image a whole disk with `dd` and output the file over SSH to a different machine. The `dd` command also has some other switches (`conv=noerror,sync`), which make it ignore errors by copying zeroes in place of unreadable data, keeping the alignment of the disk

```bash
sudo dd conv=noerror,sync if=/dev/<disk> bs=4M | ssh user@<your-pc-ip> "dd of=<path_to_image>.img"
```

I use it to occasionally make a full image backup of my raspberry pi.

#### Compression

You could also [compress it with ZSTD](-%20Configurations/Compression.md#ZSTD) before you send it (In case the network connection is slow):
```bash
# This uses a middling compression ratio, good for Raspberry Pis (tested on 4B, higher models could handle higher levlels efficiently). See the linked compression docuemnt for other options

sudo dd conv=noerror,sync if=/dev/<disk> bs=4M | zstd -4 -T0 | ssh user@<your-pc-ip> "dd of=<path_to_image>.img"
```

[Testing on a Raspberry Pi 4](-%20Scripts/Raspberry%20Pi%20disk%20backup%20speed%20test.md), copying over a gigabit LAN, with different compression ratios:

> [!IMPORTANT]  
> Observed speed is measured from the perspective of the sending `dd` command, so it takes into account that compressed data is worth more. 
> 
> It does not, however, represent the actual data transferred over the network

Tests ran for around 120 seconds each

| Compression ratio        | Observed speed               |
| ------------------------ | ---------------------------- |
| No compression (control) | 19.2 MB/s                    |
| 0                        | 20.0 MB/s                    |
| 2                        | 23.4 MB/s (Fastest observed) |
| 4                        | 19.2 MB/s                    |
| 5                        | 18.7 MB/s                    |


Or on the receiving machine (in case the transmitter's CPU is slow):
```bash
# This uses a an extreme and slow compression ratio, assuming a strong recieving server. See the linked compression docuemnt for other options

sudo dd conv=noerror,sync if=/dev/<disk> bs=4M | ssh user@<your-pc-ip> "dd of=<path_to_image>.img | zstd --ultra -22 --long=31 -T0 -v > <path_to_image>.img.zst"
```


Serial connections
---
In this guide we'll use a teminal utility called **`minicom`** for the serial terminal, and **`lrzsz`** for sending and receiving files over X/Y/ZMODEM. The guide assumes you have both of them installed.

#### Connecting to serial devices with a through a terminal:

1. First thing's first, you want to identify the serial connection:
	- For USB serial cables:
		```bash
		ls /dev/ttyUSB*
		```
	- For regular RS232:
		```
		ls /dev/ttyS*
		```
2. Configure the connection:
	```bash
	minicom -s
	```
3. Use the connection
	```bash
	minicom
	```
	If you don't know what to set, you should usually set: 
	- Baud rate to `9600` or `115200`
	- Data bits to `8`
	- Stop bits to `1`
	- Parity to `none`
	- Flow control to `XON/XOFF`
#### Sending and receiving files with XMODEM:
Replace `/dev/ttyUSB0` with the correct serial device.
- To **send a file** via XMODEM:
	```bash
	sx <file> /dev/ttyUSB0
	```
	
- To **receive a file** via XMODEM:
	```bash
	rx <file> /dev/ttyUSB0
	```




