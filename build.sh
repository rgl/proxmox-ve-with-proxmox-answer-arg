#!/usr/bin/bash
set -euxo pipefail

proxmox_ve_iso_url='https://enterprise.proxmox.com/iso/proxmox-ve_9.2-1.iso'

if [ -d /vagrant ]; then
  host_path='/vagrant'
else
  host_path="$PWD"
fi

output_iso_path="$host_path/proxmox-ve-with-proxmox-answer-arg.iso"

apt-get update
apt-get install -y --no-install-recommends \
  patch \
  squashfs-tools \
  xorriso

rm -rf tmp "$output_iso_path"
install -d tmp/{proxmox-ve,proxmox-ve-installer}
cd tmp

wget -q -O proxmox-ve.iso "$proxmox_ve_iso_url"

xorriso \
  -osirrox on \
  -indev proxmox-ve.iso \
  -extract / proxmox-ve

unsquashfs \
  -d proxmox-ve-installer \
  proxmox-ve/pve-installer.squashfs

pushd proxmox-ve-installer
patch -p0 <"$host_path/pve-installer-proxmox-answer-arg.patch"
popd

mksquashfs \
  proxmox-ve-installer \
  proxmox-ve/pve-installer.squashfs \
  -comp zstd \
  -Xcompression-level 19 \
  -b 1M \
  -noappend

remaster_args="$(
  xorriso \
    -indev proxmox-ve.iso \
    -report_el_torito as_mkisofs \
    2>/dev/null \
    | tr '\n' ' ')"

bash -euxc "xorriso -as mkisofs $remaster_args -o '$output_iso_path' proxmox-ve"
