## Virtualization

Scripts for managing virtual environments on cloud servers.
Used primarily for testing Ansible roles on isolated environments.

### Structure
```
virtualization/
├── lxc/              ## LXC container management
│   └── scripts/
│       ├── create-containers.sh
│       └── delete-containers.sh
└── kvm/              ## KVM virtual machines (TODO)
    └── scripts/
        ├── create-vm.sh
        └── delete-vm.sh
```
### LXC (Linux Containers)

#### Prerequisites
- Ubuntu server with LXD installed via cloud-init
- LXD initialized with lxd init --auto

#### Usage

## Create containers
```
./lxc/scripts/create-containers.sh <count> <name> <ubuntu-version>
```
## Examples
```
./lxc/scripts/create-containers.sh 3 clickhouse 24.04
./lxc/scripts/create-containers.sh 3 kafka 24.04
./lxc/scripts/create-containers.sh 2 postgres 24.04
```
## Delete containers
```
./lxc/scripts/delete-containers.sh <count> <name>
./lxc/scripts/delete-containers.sh 3 clickhouse
```

#### Workflow

## 1. Create containers for specific service
```
./lxc/scripts/create-containers.sh 3 clickhouse 24.04
```

## 2. Get container IPs
```
lxc list
```

## 3. Add IPs to Ansible inventory
## 4. Run Ansible playbook
## 5. Test installation
## 6. Destroy containers
```
./lxc/scripts/delete-containers.sh 3 clickhouse
```

## 7. Repeat for next service
```
./lxc/scripts/create-containers.sh 3 kafka 24.04
```

#### Use Cases
- Testing Ansible roles
- ClickHouse cluster installation testing
- Kafka cluster installation testing
- Any multi-node service testing

### KVM (TODO)

KVM scripts will be added when bare metal server is available.
Requires /dev/kvm access which is not available on Hetzner Cloud VPS.

Use cases for KVM:
- Kernel-level testing
- Different OS kernels
- Full hardware emulation
- Windows VMs

### LXC vs KVM

| Feature | LXC | KVM |
|---------|-----|-----|
| Kernel | Shared | Own |
| RAM usage | Light | Heavy |
| Start time | Seconds | Minutes |
| Ansible testing | Perfect | Works |
| Kernel testing | No | Yes |
| Available on Hetzner VPS | Yes | No |

### Server Requirements

| Containers | Recommended RAM | Server Type |
|------------|----------------|-------------|
| 1-3 | 8GB | cpx32 |
| 4-6 | 16GB | cpx41 |
| 7+ | 32GB | cpx51 |
