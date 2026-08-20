# VPC Peering & Public/Private Network Architecture Guide

This documentation provides an in-depth breakdown of how multi-VPC networking, public/private subnets, and VPC Peering work in AWS and how they are implemented using Terraform in [Practice/vpc-peering/](file:///Users/mo-jasim/Desktop/Terraform/Practice/vpc-peering).

---

## 1. Architecture Overview

```
+-----------------------------------------------------------------------------------------------+
|                                      AWS Region (ap-south-1)                                  |
|                                                                                               |
|   +---------------------------------------+       +---------------------------------------+   |
|   |         Public VPC (VPC-A)            |       |         Private VPC (VPC-B)           |   |
|   |             10.1.0.0/16               |       |             10.2.0.0/16               |   |
|   |                                       |       |                                       |   |
|   |  +---------------------------------+  |       |  +---------------------------------+  |   |
|   |  |     Public Subnet (10.1.1.0/24) |  |       |  |    Private Subnet (10.2.1.0/24) |  |   |
|   |  |                                 |  |       |  |                                 |  |   |
|   |  |   [ Public EC2 Instance ]       |  |       |  |   [ Private EC2 Instance ]      |  |   |
|   |  |   - Has Public & Private IP     |  |       |  |   - Only Private IP             |  |   |
|   |  |   - SG: Allow SSH from 0.0.0.0/0|  |       |  |   - SG: Allow SSH/Ping from     |  |   |
|   |  +-----------------|---------------+  |       |  |         10.1.0.0/16 ONLY        |  |   |
|   |                    |                  |       |  +-----------------|---------------+  |   |
|   |        [ Public Route Table ]         |       |        [ Private Route Table ]        |   |
|   |       - 0.0.0.0/0 -> IGW              |       |       - 10.1.0.0/16 -> Peering CX     |   |
|   |       - 10.2.0.0/16 -> Peering CX     |       |                                       |   |
|   +--------------------|------------------+       +--------------------|------------------+   |
|                        |                                               |                      |
|                        +------------------ VPC Peering ----------------+                      |
|                                         (pcx-xxxxxxxx)                                        |
|                                                                                               |
|         Internet Gateway (IGW)                                                                |
|                   |                                                                           |
|                   v                                                                           |
|              [ INTERNET ]                                                                     |
+-----------------------------------------------------------------------------------------------+
```

---

## 2. Core Concepts: Public vs Private VPC & Subnet

### Why do we need Non-overlapping CIDR Blocks?
* **Public VPC CIDR**: `10.1.0.0/16` (Range: `10.1.0.0` - `10.1.255.255`)
* **Private VPC CIDR**: `10.2.0.0/16` (Range: `10.2.0.0` - `10.2.255.255`)
* **Crucial Rule**: For VPC Peering to work, CIDR ranges **must never overlap**. If both were `10.0.0.0/16`, the routers would not know where to direct packets.

---

## 3. Detailed Component Breakdown

### A. Public VPC Infrastructure ([vpc.tf](file:///Users/mo-jasim/Desktop/Terraform/Practice/vpc-peering/vpc.tf))

1. **`aws_vpc.public_vpc`**: Creates isolated virtual network `10.1.0.0/16`.
2. **`aws_internet_gateway.public_igw`**: Attaches an Internet Gateway (IGW) to the VPC. This is what allows traffic to enter/leave the AWS VPC from/to the internet.
3. **`aws_subnet.public_subnet`**: Subnet with `map_public_ip_on_launch = true`. Any EC2 launched here automatically receives a reachable Public IPv4 address.
4. **`aws_route_table.public_route_table`**: Contains a default route `0.0.0.0/0` targeting the IGW (`aws_internet_gateway.public_igw.id`).
5. **`aws_route_table_association.public_rta`**: Links the route table to the subnet, making it officially a **public subnet**.

---

### B. Private VPC Infrastructure ([vpc.tf](file:///Users/mo-jasim/Desktop/Terraform/Practice/vpc-peering/vpc.tf))

1. **`aws_vpc.private_vpc`**: Creates the second isolated network `q10.2.0.0/16`.
2. **`aws_subnet.private_subnet`**: Subnet with `map_public_ip_on_launch = false`. Instances here get **only private IP addresses**.
3. **`aws_route_table.private_route_table`**: Has **NO** Internet Gateway route (`0.0.0.0/0`). It is entirely air-gapped from the public internet.
4. **`aws_route_table_association.private_rta`**: Links the private route table to the private subnet.

---

### C. VPC Peering Connection & Bi-directional Routes ([vpc.tf](file:///Users/mo-jasim/Desktop/Terraform/Practice/vpc-peering/vpc.tf))

VPC Peering works like a virtual network cable directly between the two VPCs:

1. **`aws_vpc_peering_connection.peering`**:
   * `vpc_id`: Requester VPC (`aws_vpc.public_vpc.id`)
   * `peer_vpc_id`: Accepter VPC (`aws_vpc.private_vpc.id`)
   * `auto_accept = true`: Automatically approves the peering connection since both VPCs are in the same AWS account.

2. **Cross-VPC Routing (Crucial Step!)**:
   * Creating a peering connection alone is not enough; each route table must be instructed how to send traffic to the other VPC.
   * **Route in Public RT**: Destination `10.2.0.0/16` (Private VPC) $\rightarrow$ `aws_vpc_peering_connection.peering.id`
   * **Route in Private RT**: Destination `10.1.0.0/16` (Public VPC) $\rightarrow$ `aws_vpc_peering_connection.peering.id`

---

### D. Security Groups & Instances ([main.tf](file:///Users/mo-jasim/Desktop/Terraform/Practice/vpc-peering/main.tf))

1. **Public Instance Security Group (`public_instance_sg`)**:
   * Ingress Port 22 from `0.0.0.0/0` (Allows you to SSH in from your laptop).
   * Egress All (`-1`) to `0.0.0.0/0`.

2. **Private Instance Security Group (`private_instance_sg`)**:
   * Ingress Port 22 allowed **ONLY** from `10.1.0.0/16` (Public VPC CIDR). Nobody from the public internet can SSH into this instance directly.
   * Ingress ICMP (Ping) allowed from `10.1.0.0/16` to test connectivity.

3. **Instances & State**:
   * `aws_instance.public_instance`: Deployed into `aws_subnet.public_subnet.id`.
   * `aws_instance.private_instance`: Deployed into `aws_subnet.private_subnet.id`.
   * `aws_ec2_instance_state`: Manages instance running states.

---

## 4. How to Test & Connect (Bastion / Jump Host Workflow)

Once applied (`terraform apply`), you connect to the private server using the public server as a **Bastion host (Jump Box)**:

### Step 1: Add SSH Key to SSH Agent on your Laptop
```bash
ssh-add -K ../terraform_key   # On macOS
# or
ssh-add ../terraform_key
```

### Step 2: SSH into the Public Bastion with Agent Forwarding (`-A`)
```bash
ssh -A ubuntu@<PUBLIC_INSTANCE_PUBLIC_IP>
```

### Step 3: From the Public Instance, Ping and SSH into the Private Instance
```bash
# Test network peering connectivity:
ping <PRIVATE_INSTANCE_PRIVATE_IP>

# SSH directly into the private instance:
ssh ubuntu@<PRIVATE_INSTANCE_PRIVATE_IP>
```

---

## 5. File Structure Reference

```
Practice/
├── terraform_key
├── terraform_key.pub
└── vpc-peering/
    ├── provider.tf      # AWS Provider configuration (ap-south-1)
    ├── variable.tf      # Variables for VPCs, Subnets, Instances & CIDRs
    ├── vpc.tf           # Both VPCs, Subnets, IGW, Route Tables & Peering
    ├── main.tf          # SSH Keys, Security Groups, and EC2 Instances
    ├── output.tf        # Public/Private IPs, Peering Status
    └── README.md        # Architecture documentation
```