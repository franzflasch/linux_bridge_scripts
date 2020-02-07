### Booting openwrt-x86 in qemu with a tap interface
```shell
macaddr=$(hexdump -n 6 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s:%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}')
sudo qemu-system-x86_64 -enable-kvm -curses -drive file=hostB.vdi,id=d0,if=none -device ide-hd,drive=d0,bus=ide.0 -m 1024 -netdev tap,id=mynet0,ifname=tap3,script=no,downscript=no -device e1000,netdev=mynet0,mac=$macaddr
```

### How to properly generate a valid random locally generated MAC address
https://stackoverflow.com/a/42661696/12330953  
