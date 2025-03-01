# Good to know-101
created: 2025-03-01 14:49
tags: #linux #firmware


Prerequisites
---
- You have a Raspberry PI
- You have some way to write data to an SD card
- You have an appropriate power supply (15 watts for a RPI 4)

Sources
---

> [!info] Raspberry Pi Documentation - Raspberry Pi OS  
> The official documentation for Raspberry Pi computers and microcontrollers  
> [https://www.raspberrypi.com/documentation/computers/os.html](https://www.raspberrypi.com/documentation/computers/os.html)  

A lot of options here (screen is turned through here off here): `sudo raspi-config`

LED Warning Flash Codes
---

|              |               |                                        |
| ------------ | ------------- | -------------------------------------- |
| Long flashes | Short flashes | Status                                 |
| 0            | 3             | Generic failure to boot                |
| 0            | 4             | start*.elf not found                   |
| 0            | 7             | Kernel image not found                 |
| 0            | 8             | SDRAM failure                          |
| 0            | 9             | Insufficient SDRAM                     |
| 0            | 10            | In HALT state                          |
| 2            | 1             | Partition not FAT                      |
| 2            | 2             | Failed to read from partition          |
| 2            | 3             | Extended partition not FAT             |
| 2            | 4             | File signature/hash mismatch - Pi 4    |
| 3            | 1             | SPI EEPROM error - Pi 4                |
| 3            | 2             | SPI EEPROM is write protected - Pi4    |
| 3            | 3             | I2C error - Pi 4                       |
| 3            | 4             | Secure-boot configuration is not valid |
| 4            | 4             | Unsupported board type                 |
| 4            | 5             | Fatal firmware error                   |
| 4            | 6             | Power failure type A                   |
| 4            | 7             | Power failure type B                   |

## Useful Utilities

### kmsprint

The `kmsprint` tool can be used to list the display-modes supported by the monitors attached to the Raspberry Pi. Use `kmsprint` to see details of the monitors connected to the Raspberry Pi, and `kmsprint -m` to see a list of all the display-modes supported by each monitor. You can find source code for the `kmsprint` utility [on Github](https://github.com/tomba/kmsxx).

### vcgencmd

The `vcgencmd` tool is used to output information from the VideoCore GPU on the Raspberry Pi. You can find source code for the `vcgencmd` utility [on Github](https://github.com/raspberrypi/utils/tree/master/vcgencmd).

To get a list of all commands which `vcgencmd` supports, use `vcgencmd commands`. Some useful commands and their required parameters are listed below.

### vcos

The `vcos` command has two useful sub-commands:

- `version` displays the build date and version of the firmware on the VideoCore
- `log status` displays the error log status of the various VideoCore firmware areas

### version

Displays the build date and version of the VideoCore firmware.

### get_throttled

Returns the throttled state of the system. This is a bit-pattern - a bit being set indicates the following meanings:

|   |   |   |
|---|---|---|
|Bit|Hex value|Meaning|
|0|0x1|Under-voltage detected|
|1|0x2|Arm frequency capped|
|2|0x4|Currently throttled|
|3|0x8|Soft temperature limit active|
|16|0x10000|Under-voltage has occurred|
|17|0x20000|Arm frequency capping has occurred|
|18|0x40000|Throttling has occurred|
|19|0x80000|Soft temperature limit has occurred|

### measure_temp

Returns the temperature of the SoC as measured by its internal temperature sensor;  
on Raspberry Pi 4,  
`measure_temp pmic` returns the temperature of the PMIC.

### measure_clock [clock]

This returns the current frequency of the specified clock. The options are:

|   |   |
|---|---|
|clock|Description|
|arm|ARM core(s)|
|core|GPU core|
|h264|H.264 block|
|isp|Image Sensor Pipeline|
|v3d|3D block|
|uart|UART|
|pwm|PWM block (analogue audio output)|
|emmc|SD card interface|
|pixel|Pixel valves|
|vec|Analogue video encoder|
|hdmi|HDMI|
|dpi|Display Parallel Interface|

e.g. `vcgencmd measure_clock arm`

### measure_volts [block]

Displays the current voltages used by the specific block.

|   |   |
|---|---|
|block|Description|
|core|VC4 core voltage|
|sdram_c|SDRAM Core Voltage|
|sdram_i|SDRAM I/O voltage|
|sdram_p|SDRAM Phy Voltage|

### otp_dump

Displays the content of the OTP (one-time programmable) memory inside  
the SoC. These are 32-bit values, indexed from 8 to 64. See the  
[OTP bits page](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#otp-register-and-bit-definitions) for more details.

### get_config [configuration item|int|str]

Display value of the configuration setting specified: alternatively, specify either `int` (integer) or `str` (string) to see all configuration items of the given type. For example:

`vcgencmd get_config total_mem`

returns the total memory on the device in megabytes.

### get_mem type

Reports on the amount of memory addressable by the ARM and the GPU. To show the amount of ARM-addressable memory use `vcgencmd get_mem arm`; to show the amount of GPU-addressable memory use `vcgencmd get_mem gpu`. Note that on devices with more than 1GB of memory the `arm` parameter will always return 1GB minus the `gpu`  
memory value, since the GPU firmware is only aware of the first 1GB of  
memory. To get an accurate report of the total memory on the device, see  
the  
`total_mem` configuration item - see [`get_config`](https://www.raspberrypi.com/documentation/computers/os.html#getconfig) section above.

### codec_enabled [type]

Reports whether the specified CODEC type is enabled. Possible options for type are AGIF, FLAC, H263, H264, MJPA, MJPB, MJPG, **MPG2**, MPG4, MVC0, PCM, THRA, VORB, VP6, VP8, **WMV9**, **WVC1**. Those highlighted currently require a paid for licence (see the [this config.txt section](https://www.raspberrypi.com/documentation/computers/config_txt.html#licence-key-and-codec-options)  
for more info), except on the Raspberry Pi 4 and 400, where these  
hardware codecs are disabled in preference to software decoding, which  
requires no licence. Note that because the H.265 HW block on the  
Raspberry Pi 4 and 400 is not part of the VideoCore GPU, its status is  
not accessed via this command.  

### mem_oom

Displays statistics on any OOM (out of memory) events occurring in the VideoCore memory space.

### mem_reloc_stats

Displays statistics from the relocatable memory allocator on the VideoCore.

### read_ring_osc

Returns the current speed voltage and temperature of the ring oscillator.

### vclog

`vclog` is an application to display log messages from the VideoCore GPU from Linux running on the ARM. It needs to be run as root.

`sudo vclog --msg` prints out the message log, whilst `sudo vclog --assert` prints out the assertion log.