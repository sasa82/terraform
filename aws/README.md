## AWS Infrastructure

Terraform configuration for Amazon Web Services resources.

### Resources

#### VPC
- Virtual Private Cloud with configurable CIDR
- Public and private subnets across multiple AZs
- Internet Gateway
- Route tables
- Located in vpc/

#### EC2
- Ubuntu 24.04 LTS (latest AMI auto-selected)
- t3.micro (free tier eligible)
- Security group with SSH access
- cloud-init for automatic package installation
- Located in ec2/

### Deployment Order

## 1. Create VPC first
cd vpc
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply

## 2. Create EC2 (use vpc_id and subnet_id from step 1)
cd ../ec2
cp terraform.tfvars.example terraform.tfvars
## edit terraform.tfvars with vpc_id and subnet_id
terraform init
terraform apply

### Variables

#### VPC
| Variable | Description | Default |
|----------|-------------|---------|
| region | AWS region | eu-west-1 |
| vpc_name | VPC name | test-vpc |
| vpc_cidr | VPC CIDR block | 10.0.0.0/16 |
| public_subnet_cidrs | Public subnet CIDRs | 10.0.1.0/24, 10.0.2.0/24 |
| private_subnet_cidrs | Private subnet CIDRs | 10.0.3.0/24, 10.0.4.0/24 |
| availability_zones | AZs to use | eu-west-1a, eu-west-1b |

#### EC2
| Variable | Description | Default |
|----------|-------------|---------|
| region | AWS region | eu-west-1 |
| instance_name | Instance name | test-server |
| instance_type | EC2 instance type | t3.micro |
| vpc_id | VPC ID | - |
| subnet_id | Subnet ID | - |
| root_volume_size | Root volume size GB | 20 |
| allowed_ssh_cidrs | CIDRs allowed for SSH | 0.0.0.0/0 |

### Free Tier

| Resource | Free Tier |
|----------|-----------|
| EC2 t3.micro | 750 hours/month for 12 months |
| VPC | Always free |
| Subnets | Always free |
| Internet Gateway | Always free |
| EBS Storage | 30GB free for 12 months |

### Notes

- AWS credentials configured via aws configure
- AMI automatically selects latest Ubuntu 24.04
- Never commit terraform.tfvars
- SSH username for Ubuntu instances is ubuntu not root
