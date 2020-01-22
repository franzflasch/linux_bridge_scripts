### Booting openwrt-x86 in qemu with a tap interface
```shell
sudo qemu-system-x86_64 -enable-kvm -curses -drive file=hostB.vdi,id=d0,if=none -device ide-hd,drive=d0,bus=ide.0 -m 1024 -netdev tap,id=mynet0,ifname=tap3,script=no,downscript=no -device e1000,netdev=mynet0,mac=52:55:00:d1:55:01
```
