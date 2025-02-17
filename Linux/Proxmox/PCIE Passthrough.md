# Steps to Configure VFIO for GPU Passthrough on Proxmox


Terminology, general knowledge
---
- PCIE passthrough allows you to pass through devices completely (Like Ethernet ports, certain USB devices, storage devices, GPUs, etc..), as if they were connected to the virtual machine.


Prerequisites
---
- A motherboard and a CPU supporting IOMMU. Generally, anything modern supports it, even consumer grade.
- IOMMU is enabled in the BIOS/EFI
- A GPU supporting IOMMU (Other devices work better with this technology, but GPUs specifically sometimes have issues)


Sources
---
[Proxmox wiki](https://pve.proxmox.com/wiki/PCI_Passthrough)

https://www.youtube.com/watch?v=GoZaMgEgrHw
https://www.youtube.com/watch?v=_hOBAGKLQkI
https://www.youtube.com/watch?v=IE0ew8WwxLM

Configuration
---
### Step 1: Edit GRUB
1. Execute: `nano /etc/default/grub`
2. Change the line: `GRUB_CMDLINE_LINUX_DEFAULT="quiet"` to: `GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt pcie_acs_override=downstream,multifunction nofb nomodeset video=vesafb:off,efifb:off"`
3. Save the file and exit the text editor.

### Step 2: Update GRUB
1. Execute the command: `update-grub`

### Step 3: Edit the Module Files
1. Execute: `nano /etc/modules`
2. Add the following lines:
   - `vfio`
   - `vfio_iommu_type1`
   - `vfio_pci`
   - `vfio_virqfd`
3. Save the file and exit the text editor.

### Step 4: IOMMU Remapping

> [!IMPORTANT]
> Make sure that IOMMU is enabled in your BIOS as well. You have to look for that yourself. Just search `IOMMU (motherboard brand)`

#### a) Edit `iommu_unsafe_interrupts.conf`
1. Execute: `nano /etc/modprobe.d/iommu_unsafe_interrupts.conf`
2. Add the following line: `options vfio_iommu_type1 allow_unsafe_interrupts=1`
3. Save the file and exit the text editor.

#### b) Edit `kvm.conf`
1. Execute: `nano /etc/modprobe.d/kvm.conf`
2. Add the following line: `options kvm ignore_msrs=1`
3. Save the file and exit the text editor.

### Step 5: Blacklist the GPU Drivers
1. Execute: `nano /etc/modprobe.d/blacklist.conf`
2. Add the following lines:
   - `blacklist radeon`
   - `blacklist nouveau`
   - `blacklist nvidia`
   - `blacklist nvidiafb`
3. Save the file and exit the text editor.

### Step 6: Adding GPU to VFIO
#### a) Identify GPU
1. Execute: `lspci -v`
2. Look for your GPU and take note of the first set of numbers.

#### b) Get GPU Vendor Number
1. Execute: `lspci -n -s (PCI card address)`
   This command gives you the GPU vendor number.

#### c) Edit `vfio.conf`
1. Execute: `nano /etc/modprobe.d/vfio.conf`
2. Add the following line with your GPU number and Audio number: `options vfio-pci ids=(GPU number,Audio number) disable_vga=1`
3. Save the file and exit the text editor.

### Step 7: Update and Restart
1. Execute: `update-initramfs -u`
2. Restart your Proxmox Node.