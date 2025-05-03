# Cisco firmware 

tags: #cisco #switch #router #basic #firmware


References
---
[Firmware update](Firmware%20update.md)

Naming convention
---

Cisco categorizes firmware in multiple different ways, but the naming convention remains the same across versions. The convention is:

`<platform>-<feature_set>-<compression>.<version>.<releasetype>`

For example:  **`C3900-universalk9-mz.SPA.151-4.M1.bin`**
	- **C3900**: Indicates the platform (e.g., 3900 series router).
	- **universalk9**: Indicates the feature set (e.g., universal with strong encryption).
	- **mz**: Denotes a compressed image.
	- **SPA**: Indicates specific packaging or distribution (Security, Performance, Availability).
	- **151-4.M1**: Version number (15.1, sub-release 4, Maintenance 1).

#### Platform

Platforms refer to the physical hardware. Usually only direct matches are compatible, different versions (Like c3550 and c3550x) of the same hardware usually don't work.

| **Platform Identifier**   | **Device/Hardware**                                  |
|---------------------------|------------------------------------------------------|
| `C1900`                   | Cisco 1900 Series Routers                            |
| `C2900`                   | Cisco 2900 Series Routers                            |
| `C3900`                   | Cisco 3900 Series Routers                            |
| `ISR4400`                 | Integrated Services Routers (ISR) 4400 Series        |
| `ASR1000`                 | Aggregation Services Router (ASR) 1000 Series        |
| `Nexus9000`               | Nexus 9000 Series Switches                           |
| `Catalyst9200`            | Catalyst 9200 Series Switches                        |
| `C6800`                   | Catalyst 6800 Series Switches                        |
| `ME3600X`                 | Metro Ethernet Series Routers                        |
#### Feature set

*One of the most important markers of the image*

If you have a modern enough device to be listed, you could try the [Cisco feature navigator](https://cfnng.cisco.com/)

This is the most important. This may indicate, for example, whether you have [IPv6](../IPv6/IPv6.md) support or not.

The most common you might encounter are (with their hallmark features):
- `ipbase`: Poor to no IPv6 support.
- `ipservices`: Good IPv6 support.
- `universal`: Pretty good support for everything.

A more complete table of features:

| **Feature Set Identifier** | **Description**                                                                  |
| -------------------------- | -------------------------------------------------------------------------------- |
| `ipbase`                   | Basic IP routing features, including IPv4, IPv6 (not always), and basic QoS.     |
| `ipservices`               | More advanced features, like IPv6 OSPF, HSRP, and other things                   |
| `entservices`              | Enterprise services, adding Layer 3 routing protocols, MPLS, and QoS.            |
| `advipservices`            | Advanced IP services including MPLS, IPsec, IPv6, VPN, and enhanced security.    |
| `advsecurity`              | Advanced security services including VPNs, firewall, IPsec, and encryption.      |
| `security`                 | Security features, including firewall, VPN, and encryption support.              |
| `spservices`               | Service provider features such as MPLS and high-performance routing.             |
| `universal`                | Universal image with all features, but features are activated based on licenses. |
| `metroipaccess`            | Metro Ethernet routing features for Layer 2 and Layer 3 services.                |

##### Affixes
There are some standardized affixes that may be found on multiple feature sets, these include:

- `k9`: For example: `c3550-ipservicesk9-tar.122-44.SE6`, means that it includes cryptographic features. This refers to very basic cryptographic features, like SSH. This affix might not be present on newer images (since it should be taken for granted nowadays).


For switches you might find `lanbase` images. They are only capable of layer 2 (except for management IP).

#### Compression
TODO

Not too important, you probably don't have to deal with it yourself

#### Version

The higher the version, the better, but there are exceptions. They usually take noticeably more space as time goes on.

Their format is the following

```html
<major_release>.<minor_release>.<maintenance_release>[S][M/T]
```

Example: `15.2(4)SM3`
- **15**: Major release 
- **2**: Minor release
- **(4)**: Maintenance release
- **S**: Service Provider release, designed for the needs of telecom operators and large ISPs.
- **M**: Mainline release (feature releases are "T" for Technology releases)
- **3**: Additional identifier to distinguish specific builds or bug fixes.

This is less important than the [Feature set](#Feature%20set), and in some cases an older version might have more features because it has a higher final build number at the end.

(This is the case between the c3550-ipservicesk9 122-44 and 122-54 releases, where the 122-44 has more features because it is up to SE6, in contrast to SE with the 12-54)

