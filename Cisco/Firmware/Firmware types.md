# Cisco firmware 
created: 2025-02-27 13:28
tags: #cisco #switch #router #basic #firmware

Naming convention
---

Cisco categorizess firmware in multiple different ways, but the name convention remains the same accross versions. The convention is:

`<Platform>-<FeatureSet>-<Compression>.<Version>.<ReleaseType>`

For example:  **`C3900-universalk9-mz.SPA.151-4.M1.bin`**
	- **C3900**: Indicates the platform (e.g., 3900 series router).
	- **universalk9**: Indicates the feature set (e.g., universal with strong encryption).
	- **mz**: Denotes a compressed image.
	- **SPA**: Indicates specific packaging or distribution (Security, Performance, Availability).
	- **151-4.M1**: Version number (15.1, sub-release 4, Maintenance 1).

#### Platform:

| **Platform Identifier**  | **Device/Hardware**                                  |
|--------------------------|------------------------------------------------------|
| `C1900`                   | Cisco 1900 Series Routers                            |
| `C2900`                   | Cisco 2900 Series Routers                            |
| `C3900`                   | Cisco 3900 Series Routers                            |
| `ISR4400`                 | Integrated Services Routers (ISR) 4400 Series        |
| `ASR1000`                 | Aggregation Services Router (ASR) 1000 Series        |
| `Nexus9000`               | Nexus 9000 Series Switches                           |
| `Catalyst9200`            | Catalyst 9200 Series Switches                        |
| `C6800`                   | Catalyst 6800 Series Switches                        |
| `ME3600X`                 | Metro Ethernet Series Routers                        |
#### Feature set:

This is the most important. This may indicate whether you have [IPv6](../IPv6/IPv6.md) support or not

| **Feature Set Identifier**     | **Description**                                                                 |
|--------------------------------|---------------------------------------------------------------------------------|
| `ipbase`                       | Basic IP routing features, including IPv4, IPv6, and basic QoS.                  |
| `entservices`                  | Enterprise services, adding Layer 3 routing protocols, MPLS, and QoS.            |
| `advipservices`                | Advanced IP services including MPLS, IPsec, IPv6, VPN, and enhanced security.    |
| `advsecurity`                  | Advanced security services including VPNs, firewall, IPsec, and encryption.      |
| `security`                     | Security features, including firewall, VPN, and encryption support.              |
| `spservices`                   | Service provider features such as MPLS and high-performance routing.             |
| `universal`                    | Universal image with all features, but features are activated based on licenses. |
| `universalk9`                  | Universal image with cryptographic support (strong encryption).                  |
| `universalk9_npe`              | Universal image without strong encryption (No Payload Encryption) for export.    |
| `metroipaccess`                | Metro Ethernet routing features for Layer 2 and Layer 3 services.                |



Prerequisites
---





Sources
---


Configuration
---


Minimum working config examples:
---