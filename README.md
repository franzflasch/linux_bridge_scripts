# Simple script for setting up bridges in linux using brctl

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
