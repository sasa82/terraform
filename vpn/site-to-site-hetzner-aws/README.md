## Site-to-Site VPN - Hetzner to AWS
## Hybrid Network Infrastructure

IPSec VPN tunnel between Hetzner private network and AWS VPC.
Enables private communication between both networks without traffic
going through public internet.

### Architecture

Hetzner Network (10.0.0.0/8) <----IPSec Tunnel----> AWS VPC (172.16.0.0/16)
       |                                                      |
  test-server                                            EC2 instances
  (VPN Gateway)                                    (reachable from Hetzner)

### Prerequisites

#### Must Be Done Manually Before Running Terraform

1. Hetzner Server Firewall
   Open these ports on Hetzner VPN gateway server:
   Via UFW on server:
   ufw allow 500/udp
   ufw allow 4500/udp

2. AWS EC2 Security Group (AWS Console)
   Add inbound rule to EC2 security group:
   - Type: All traffic
   - Protocol: All
   - Source: 10.0.0.0/8 (Hetzner network)

3. Hetzner Network Route (Hetzner Web UI)
   Networks -> your-network -> Routes -> Add Route:
   - Destination: 172.16.0.0/16
   - Gateway: 10.0.1.1 (VPN gateway private IP)
   Note: Hetzner will warn about destination outside network range - this is expected!

4. Gateway Masquerade Rule (on VPN gateway server)
   Run on Hetzner VPN gateway server:
   iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -d 172.16.0.0/16 -o enp7s0 -j MASQUERADE
   apt-get install -y iptables-persistent
   netfilter-persistent save

#### Infrastructure Must Already Exist
- Hetzner server running and accessible via SSH
- AWS VPC with public and private subnets
- AWS EC2 instance running
- SSH key pair on local machine (~/.ssh/id_rsa)

### Required Values

Collect these before filling terraform.tfvars:

From hetzner/server terraform output:
- server_public_ip  -> hetzner_server_public_ip
- server_private_ip -> hetzner_server_private_ip

From aws/vpc terraform output:
- vpc_id            -> aws_vpc_id

Get route table IDs:
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=YOUR_VPC_ID" \
  --query 'RouteTables[*].{ID:RouteTableId,Tags:Tags}' \
  --output json \
  --region eu-west-1

### Deployment

cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

terraform init
terraform apply

Terraform will automatically:
- Create AWS VPN gateway and connection
- Add routes to public and private route tables
- SSH into Hetzner server
- Install strongSwan if not present
- Configure IPSec tunnel with auto-generated PSK
- Start and enable strongSwan service

### Adding New Servers to Hetzner Network

Every new server added to Hetzner private network needs:

1. OS route to AWS network (on new server):
   ip route add 172.16.0.0/16 via 10.0.0.1

   Make persistent:
   echo "172.16.0.0/16 via 10.0.0.1" >> /etc/network/interfaces.d/vpn-routes

2. Hetzner Web UI route (one time for whole network):
   Networks -> your-network -> Routes -> Add Route:
   - Destination: 172.16.0.0/16
   - Gateway: 10.0.1.1

Note: Gateway masquerade rule covers all servers automatically
No additional configuration needed on VPN gateway for new servers

### Verify Connection

On Hetzner VPN gateway:
ipsec status
ping AWS_EC2_PRIVATE_IP

On any Hetzner server in private network:
ping AWS_EC2_PRIVATE_IP

On AWS EC2:
ping HETZNER_SERVER_PRIVATE_IP
nmap -sn 10.0.1.0/24

### Troubleshooting

Check tunnel status on Hetzner:
ipsec status
ipsec statusall

Check routes on Hetzner:
ip route show | grep 172.16

Check traffic on gateway:
tcpdump -i enp7s0 src NEW_SERVER_IP
tcpdump -i eth0 dst AWS_EC2_IP

Check AWS VPN tunnel status:
aws ec2 describe-vpn-connections \
  --vpn-connection-ids YOUR_VPN_CONNECTION_ID \
  --query 'VpnConnections[*].VgwTelemetry' \
  --region eu-west-1

Restart strongSwan if tunnel is down:
systemctl restart strongswan-starter

Check masquerade rules:
iptables -t nat -L POSTROUTING -n -v

### Outputs

| Output | Description |
|--------|-------------|
| vpn_connection_id | AWS VPN connection ID |
| vpn_gateway_id | AWS Virtual Private Gateway ID |
| tunnel1_address | AWS VPN tunnel 1 outside IP |
| tunnel2_address | AWS VPN tunnel 2 outside IP |
| tunnel1_preshared_key | Tunnel 1 PSK (sensitive) |
| tunnel2_preshared_key | Tunnel 2 PSK (sensitive) |

### Notes

- AWS VPN connection takes 3-7 minutes to create
- Only tunnel1 is used, tunnel2 is AWS redundancy
- strongSwan service is enabled and persists after server reboot
- SSH key (~/.ssh/id_rsa) must have access to Hetzner server
- Hetzner Web UI network route covers all servers in network
- Each new server needs OS route: ip route add 172.16.0.0/16 via 10.0.0.1
- Gateway masquerade uses enp7s0 (private interface) not eth0 (public)
