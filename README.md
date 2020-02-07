# Simple script for setting up bridges in linux

## Examples
### Create a new bridge named 'qemu_bridge' with tap3 and tap4 interface using ip address '192.168.42.50/24" and bring the bridge up
```shell
./setup_bridge.sh -b=qemu_bridge --addbridge -a -i=tap3 -i=tap4 -p="192.168.42.50/24" -u
```

### Create a new bridge
```shell
./setup_bridge.sh -b=qemu_bridge --addbridge
```

### Delete a bridge
```shell
./setup_bridge.sh -b=qemu_bridge --delbridge
```

### Adding new interfaces to an existing bridge
```shell
./setup_bridge.sh -b=qemu_bridge -a -i=tap5 -i=tap6
```

### Removing interfaces from an existing bridge
```shell
./setup_bridge.sh -b=qemu_bridge -r -i=tap5
```

### Remove all interfaces from an existing bridge
```shell
./setup_bridge.sh -b=qemu_bridge --delall
```

### Set IP Address of bridge
```shell
./setup_bridge.sh -b=qemu_bridge -p="192.168.42.50/24"
```

### Show current attached interfaces of bridge
```shell
./setup_bridge.sh -b=qemu_bridge -s
```

### Bring the bridge and all its interfaces up
```shell
./setup_bridge.sh -b=qemu_bridge -u
```

### Bring the bridge and all its interfaces down
```shell
./setup_bridge.sh -b=qemu_bridge -d
```

### Notes
Warning: if you have docker installed on your host, it may have created an iptable rule that forbids IP forwarding: the symptom will be that ARP will work, allowing your containers to see each other, but all IP traffic between your containers will be blocked. In that case, you need to disable iptables for network bridges (as root):

```shell
$ echo 0  | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
```

You can monitor the IP traffic between the two containers using tshark (or tcpdump):

```shell
$ sudo tshark -i br0
```

### Some interesting links
http://www.kaizou.org/2018/06/qemu-bridge.html  

