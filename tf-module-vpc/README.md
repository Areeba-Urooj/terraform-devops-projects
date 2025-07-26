# Terraform AWS Infrastructure with Official Modules

This Terraform configuration demonstrates infrastructure as code using official Terraform AWS modules to create a VPC and EC2 instance in the `eu-north-1` region (Stockholm).

## Project Overview

This project leverages official Terraform modules from the Terraform Registry to create AWS infrastructure following best practices. Instead of writing custom resource blocks, it uses community-maintained, production-ready modules that provide sensible defaults and advanced configuration options.

## Architecture

- **Provider**: AWS (eu-north-1 region - Stockholm)
- **Modules Used**:
  - `terraform-aws-modules/vpc/aws` (v6.0.1)
  - `terraform-aws-modules/ec2-instance/aws` (v6.0.2)
- **Instance Type**: t3.micro (AWS Free Tier eligible)
- **AMI**: ami-09278528675a8d54e (Amazon Linux 2023)
- **Network**: Multi-AZ VPC with public and private subnets

## Infrastructure Components

### VPC Module (`terraform-aws-modules/vpc/aws`)
- **VPC CIDR**: `10.0.0.0/16`
- **Availability Zones**: All available AZs in eu-north-1 region
- **Public Subnet**: `10.0.0.0/24` (internet-accessible)
- **Private Subnet**: `10.0.1.0/24` (internal only)
- **Auto-created Components**:
  - Internet Gateway
  - NAT Gateway (if enabled)
  - Route Tables
  - Route Table Associations

### EC2 Module (`terraform-aws-modules/ec2-instance/aws`)
- **Instance Name**: `single-instance`
- **Deployment**: Public subnet for internet access
- **Environment**: Tagged as `dev`
- **Auto-configured**:
  - Security groups (default)
  - Instance profile (if specified)
  - EBS optimization
  - Monitoring settings

## Benefits of Using Modules

1. **Best Practices**: Modules implement AWS well-architected principles
2. **Maintainability**: Community-maintained and regularly updated
3. **Flexibility**: Extensive configuration options without custom code
4. **Consistency**: Standardized resource naming and tagging
5. **Time-Saving**: Reduces boilerplate code significantly

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (v1.0+ recommended)
- Internet connectivity to download modules from Terraform Registry
- AWS account with VPC and EC2 creation permissions

## Usage

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd <project-directory>
```

### 2. Initialize Terraform
```bash
terraform init
```
This command will download the required modules from the Terraform Registry.

### 3. Plan Deployment
```bash
terraform plan
```

### 4. Apply Configuration
```bash
terraform apply
```
Type `yes` when prompted to confirm the deployment.

## Terraform Apply Output

Below are the screenshots showing the complete Terraform deployment process using modules:

![Terraform Apply Output 1](images/terraform-apply-1.png)
*Terraform initialization and module download*

![Terraform Apply Output 2](images/terraform-apply-2.png)
*Planning phase showing resources to be created*

![Terraform Apply Output 3](images/terraform-apply-3.png)
*VPC module resource creation begins*

![Terraform Apply Output 4](images/terraform-apply-4.png)
*VPC components being provisioned*

![Terraform Apply Output 5](images/terraform-apply-5.png)
*EC2 module initialization and planning*

![Terraform Apply Output 6](images/terraform-apply-6.png)
*EC2 instance creation in progress*

![Terraform Apply Output 7](images/terraform-apply-7.png)
*Infrastructure deployment completion*

![Terraform Apply Output 8](images/terraform-apply-8.png)
*Final output with resource summaries and any module outputs*

## AWS Console Verification

Screenshots from the AWS Management Console showing the infrastructure created by the modules:

![AWS Console View 1](images/aws-console-1.png)
*VPC overview showing subnets, route tables, and internet gateway*

![AWS Console View 2](images/aws-console-2.png)
*EC2 instance details and configuration*

![AWS Console View 3](images/aws-console-3.png)
*Security groups and networking configuration*

## File Structure

```
.
├── main.tf                 # Main Terraform configuration with modules
├── README.md              # This file
├── .terraform/            # Terraform working directory (auto-generated)
│   └── modules/           # Downloaded modules
└── images/                # Screenshots directory
    ├── terraform-apply-1.png
    ├── terraform-apply-2.png
    ├── terraform-apply-3.png
    ├── terraform-apply-4.png
    ├── terraform-apply-5.png
    ├── terraform-apply-6.png
    ├── terraform-apply-7.png
    ├── terraform-apply-8.png
    ├── aws-console-1.png
    ├── aws-console-2.png
    └── aws-console-3.png
```

## Configuration Breakdown

### Data Source
```hcl
data "aws_availability_zones" "vpc-az" {
  state = "available"
}
```
- Dynamically fetches all available AZs in the region
- Ensures subnets are distributed across multiple AZs for high availability

### VPC Module Configuration
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs = data.aws_availability_zones.vpc-az.names
  public_subnets = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/24"]
}
```

**What this creates automatically**:
- VPC with specified CIDR block
- Internet Gateway
- Public route table with route to IGW
- Private route table
- Subnet route table associations
- Default security group
- Default NACL

### EC2 Module Configuration
```hcl
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"
  
  name = "single-instance"
  ami = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  subnet_id = module.vpc.public_subnets[0]
}
```

**What this creates automatically**:
- EC2 instance with specified configuration
- Default security group (if not specified)
- Instance profile (if specified)
- EBS optimization settings
- Detailed monitoring (if enabled)

## Module Outputs

### VPC Module Outputs (Available)
- `vpc_id` - ID of the VPC
- `public_subnets` - List of public subnet IDs
- `private_subnets` - List of private subnet IDs
- `internet_gateway_id` - ID of the Internet Gateway
- `public_route_table_ids` - List of public route table IDs

### EC2 Module Outputs (Available)
- `id` - EC2 instance ID
- `public_ip` - Public IP address (if assigned)
- `private_ip` - Private IP address
- `security_groups` - List of associated security group IDs

To view outputs:
```bash
terraform output
```

## Advanced Module Features

### VPC Module Capabilities
- **Multi-AZ Deployment**: Automatic subnet distribution
- **NAT Gateway**: Can be enabled for private subnet internet access
- **VPC Endpoints**: Support for S3, DynamoDB, and other services
- **Flow Logs**: VPC flow logging configuration
- **DNS Settings**: Custom DNS resolution options

### EC2 Module Capabilities
- **Auto Scaling**: Integration with Auto Scaling Groups
- **Load Balancing**: Target group attachments
- **Storage**: EBS volume configuration and encryption
- **Networking**: Multiple network interface support
- **Monitoring**: CloudWatch integration

## Customization Examples

### Enable NAT Gateway for Private Subnets
```hcl
module "vpc" {
  # ... existing configuration
  enable_nat_gateway = true
  single_nat_gateway = true  # Use single NAT for cost optimization
}
```

### Add Custom Security Group to EC2
```hcl
module "ec2-instance" {
  # ... existing configuration
  vpc_security_group_ids = [aws_security_group.custom_sg.id]
}
```

### Enable Detailed Monitoring
```hcl
module "ec2-instance" {
  # ... existing configuration
  monitoring = true
}
```

## Cost Optimization

- **t3.micro**: Free Tier eligible (750 hours/month)
- **VPC Components**: No additional charges for basic VPC resources
- **NAT Gateway**: Not enabled by default (would incur hourly charges)
- **Data Transfer**: Standard AWS rates apply

## Security Considerations

### Default Security
- VPC module creates isolated network environment
- EC2 module uses default security group (restrictive by default)
- No direct internet access to private subnets

### Recommendations for Production
- Define custom security groups with minimal required access
- Enable VPC Flow Logs for network monitoring
- Use private subnets for application servers
- Implement bastion hosts for secure access
- Enable encryption for EBS volumes

## Troubleshooting

### Module Download Issues
```bash
# Clear Terraform cache and reinitialize
rm -rf .terraform
terraform init
```

### Version Conflicts
```bash
# Lock provider versions
terraform providers lock -platform=linux_amd64
```

### Region-Specific Issues
- Verify AMI availability in eu-north-1
- Check service availability in the region
- Confirm AZ availability

### Common Commands
```bash
# View downloaded modules
terraform providers

# Check module documentation
terraform providers schema -json

# Validate configuration
terraform validate

# Format code
terraform fmt
```

## Extending This Project

### Possible Enhancements
- Add Application Load Balancer module
- Implement Auto Scaling Group module
- Add RDS module for database
- Include CloudWatch monitoring module
- Implement ECS/EKS modules for containers

### Module Combinations
```hcl
# Example: Add ALB module
module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
  # ... configuration
}

# Example: Add RDS module
module "rds" {
  source = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"
  # ... configuration
}
```

## Module Documentation

- **VPC Module**: [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- **EC2 Module**: [terraform-aws-modules/ec2-instance/aws](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
- **All AWS Modules**: [Terraform AWS Modules Organization](https://github.com/terraform-aws-modules)

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

This will remove all infrastructure created by both modules.

## Best Practices Demonstrated

1. **Module Versioning**: Pinned to specific versions for reproducibility
2. **Data Sources**: Dynamic AZ discovery for flexibility
3. **Tagging Strategy**: Consistent resource tagging
4. **Network Design**: Separation of public and private subnets
5. **Documentation**: Clear variable and output definitions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test with `terraform plan`
4. Update documentation if needed
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Author**: Your Name  
**Last Updated**: $(date)  
**Terraform Version**: v1.0+  
**Module Versions**: VPC v6.0.1, EC2 v6.0.2
