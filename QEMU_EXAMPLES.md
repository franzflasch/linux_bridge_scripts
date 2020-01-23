### Booting openwrt-x86 in qemu with a tap interface
```shell
macaddr=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:\4:\5:\6/')
sudo qemu-system-x86_64 -enable-kvm -curses -drive file=hostB.vdi,id=d0,if=none -device ide-hd,drive=d0,bus=ide.0 -m 1024 -netdev tap,id=mynet0,ifname=tap3,script=no,downscript=no -device e1000,netdev=mynet0,mac=$macaddr
```
