# About

[![Build](https://github.com/rgl/proxmox-ve-with-proxmox-answer-arg/actions/workflows/build.yml/badge.svg)](https://github.com/rgl/proxmox-ve-with-proxmox-answer-arg/actions/workflows/build.yml)

This remasters the [Proxmox VE ISO](https://enterprise.proxmox.com/iso) to have the `proxmox-answer={url}` kernel command line arg to download the pve-installer answer file as a simple HTTP GET request.

This makes it possible to iPXE boot the installation from a simpler HTTP server.

## Usage

Download [a release](https://github.com/rgl/proxmox-ve-with-proxmox-answer-arg/releases) and extract it into your iPXE server, e.g.:

```bash
cd /ipxe
install -d proxmox-ve
cd proxmox-ve
wget \
    -q \
    -O proxmox.iso \
    https://github.com/rgl/proxmox-ve-with-proxmox-answer-arg/releases/download/v9.2/proxmox-ve-with-proxmox-answer-arg.iso
7z e proxmox.iso boot/{initrd.img,linux26}
mv linux26 vmlinuz
```

Configure your iPXE server to boot proxmox-ve as, e.g.:

```
set base http://example.com/proxmox-ve
set config ${base}/config/${netX/mac}
initrd ${base}/initrd.img
initrd ${base}/proxmox.iso proxmox.iso
chain --autofree --replace \
  ${base}/vmlinuz \
  ramdisk_size=16777216 \
  rw \
  proxmox-start-auto-installer \
  proxmox-answer=${config}/answer.toml
```

## Development

Install the [`debian-13-uefi-amd64` vagrant box](https://github.com/rgl/debian-vagrant).

Build the iso:

```bash
time vagrant up --no-destroy-on-error | tee provision.log
7z l proxmox-ve-with-proxmox-answer-arg.iso
```
