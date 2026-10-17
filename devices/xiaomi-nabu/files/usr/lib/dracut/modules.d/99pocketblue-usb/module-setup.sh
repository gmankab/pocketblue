#!/bin/bash

check() { return 0; }
depends() { echo systemd; }

install() {
  inst_multiple bash setsid stty sleep dmesg journalctl cat ls uname false
  inst_simple "$moddir/pocketblue-usb-shell" /usr/bin/pocketblue-usb-shell
  inst_simple "$moddir/pocketblue-logs" /usr/bin/pocketblue-logs
  inst_simple "$moddir/pocketblue-usb-debug.service" /usr/lib/systemd/system/pocketblue-usb-debug.service
  inst_simple "$moddir/emergency.target.conf" /usr/lib/systemd/system/emergency.target.d/90-pocketblue-usb.conf
  inst_simple "$moddir/dracut-initqueue.service.conf" /usr/lib/systemd/system/dracut-initqueue.service.d/90-pocketblue-force-emergency.conf
  inst_simple "$moddir/sysroot.mount.conf" /usr/lib/systemd/system/sysroot.mount.d/90-pocketblue-force-emergency.conf
}
