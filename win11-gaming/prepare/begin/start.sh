#!/bin/bash
## Helpful to read output when debugging
set -x

# Stop display manager
systemctl stop sddm.service
systemctl stop display-manager.service
## Uncomment the following line if you use GDM
#killall gdm-x-session

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
#echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

# Unload all Nvidia drivers
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia


virsh nodedev-detach pci_0000_0c_00_0
virsh nodedev-detach pci_0000_0c_00_1



## Load vfio
#modprobe vfio
#modprobe vfio_iommu_type1
modprobe vfio_pci

