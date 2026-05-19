## Hetzner Cloud Infrastructure

Terraform configuration for Hetzner Cloud resources.

### Resources

#### Private Network
- Private network with configurable IP range
- Multiple subnets support
- Located in private-network/

#### Server
- Ubuntu 24.04 LTS
- Configurable server type (cpx32 recommended for LXC)
- SSH key management
- Firewall rules
- cloud-init for automatic package installation
- Located in server/

### Deployment Order

## 1. Create private network first
cd private-network
cp terraform.tfvars.example terraform.tfvars
## edit terraform.tfvars with your token
terraform init
terraform apply

## 2. Create server (use network_id from step 1)
cd ../server
cp terraform.tfvars.example terraform.tfvars
## edit terraform.tfvars with your token and network_id
terraform init
terraform apply

### Variables

#### Private Network
| Variable | Description | Default |
|----------|-------------|---------|
| hcloud_token | Hetzner API token | - |
| network_name | Network name | prod-network |
| ip_range | Network CIDR | 10.0.0.0/8 |
| network_zone | Network zone | eu-central |

#### Server
| Variable | Description | Default |
|----------|-------------|---------|
| hcloud_token | Hetzner API token | - |
| server_name | Server name | test-server |
| server_type | Server type | cpx32 |
| server_image | OS image | ubuntu-24.04 |
| location | Datacenter location | nbg1 |
| network_id | Private network ID | - |
| private_ip | Server private IP | 10.0.1.1 |

### Server Types

| Type | vCPUs | RAM | Price/month | KVM Support |
|------|-------|-----|-------------|-------------|
| cpx32 | 4 | 8GB | ~13 EUR | No |
| cpx41 | 8 | 16GB | ~26 EUR | No |
| ccx33 | 4 | 16GB | ~40 EUR | No |

### Notes

- API token is project-scoped in Hetzner
- Token generated inside a project creates all resources in that project
- Never commit terraform.tfvars as it contains API token
- KVM nested virtualization not available on Hetzner Cloud VPS
- Use LXC for container-based virtualization instead
