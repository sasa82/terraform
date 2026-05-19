## Terraform Infrastructure

Multi-cloud infrastructure management using Terraform.
Covers server provisioning, networking and virtualization across multiple cloud providers.

### Structure
```
terraform/
│
├── hetzner/
│   ├── private-network/     ## Hetzner private network
│   └── server/              ## Hetzner server
│
├── aws/
│   ├── vpc/                 ## AWS Virtual Private Cloud
│   └── ec2/                 ## AWS EC2 instance
│
├── azure/                   ## Coming soon
│   ├── vnet/
│   └── vm/
│
└── virtualization/
    ├── lxc/                 ## LXC container scripts
    └── kvm/                 ## KVM scripts (TODO)
```
### Providers

| Provider | Status | Resources |
|----------|--------|-----------|
| Hetzner  | ✅ Done | Server, Private Network |
| AWS      | ✅ Done | EC2, VPC |
| Azure    | ⬜ Todo | VM, VNet |

### Prerequisites

- Terraform >= 1.0
- AWS CLI configured
- Hetzner API token
- SSH key pair (~/.ssh/id_rsa.pub)

### Quick Start

## Hetzner
```
cd hetzner/private-network && terraform init && terraform apply
cd hetzner/server && terraform init && terraform apply
```

## AWS
```
cd aws/vpc && terraform init && terraform apply
cd aws/ec2 && terraform init && terraform apply
```

### Modules

- [Hetzner](./hetzner/README.md)
- [AWS](./aws/README.md)
- [Virtualization](./virtualization/README.md)

### Known Issues

- cloud-init on Hetzner requires single hash in cloud-config header
- KVM nested virtualization not available on Hetzner Cloud VPS
- Use LXC for container-based virtualization instead
