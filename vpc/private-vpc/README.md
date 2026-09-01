# Fully Isolated AWS Private VPC with EC2 Instance Connect Endpoint

This project provisions a secure, private-only AWS network using Terraform. The architecture contains no Internet Gateway and assigns no public IP addresses, preventing all direct public inbound/outbound internet traffic. Secure SSH access is established using an **AWS EC2 Instance Connect Endpoint (EICE)**.

---

## Connect Instance
ssh -i ../../terraform_key -o ProxyCommand="aws ec2-instance-connect open-tunnel --instance-id <INSTANCE_ID>" ubuntu@<PRIVATE_IP>

## Architecture Overview
├── terraform_key
├── terraform_key.pub
└── vpc/
    └── private-vpc/
        ├── main.tf        # AMI lookup, Key pair, Security groups, EC2 instance
        ├── vpc.tf         # VPC, Subnet, Route tables, EIC Endpoint
        ├── variable.tf    # Parameterized input variables
        ├── provider.tf    # AWS provider configuration
        ├── terraform.tf   # Terraform version and provider constraints
        ├── output.tf      # Output values and generated SSH command
        └── README.md