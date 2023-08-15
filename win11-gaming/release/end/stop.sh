#!/bin/bash
set -x


#sleep 10
virsh nodedev-reattach pci_0000_0c_00_0
virsh nodedev-reattach pci_0000_0c_00_1


## Unload vfio
#modprobe -r vfio
#modprobe -r vfio_iommu_type1
modprobe -r vfio_pci

while [ 1 ];
do
  qemu_pid=$(ps aux | grep qemu-system | grep -v grep)
  sleep 5
  if [ "$qemu_pid" == "" ] ;
  then
    break
  fi
done

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
#echo 1 > /sys/class/vtconsole/vtcon1/bind


echo "loading nvidia mod"
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia
echo "loaded nvidia mod"


#nvidia-xconfig --query-gpu-info > /dev/null 2>&1
#echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

echo "begin start display manager"

# Restart Display Manager
#systemctl start sddm.service
systemctl start display-manager.service

