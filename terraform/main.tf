# This file is the starting point for Terraform in this project.
# It tells Terraform which version of the Terraform CLI and which cloud provider
# plugins are required before any infrastructure is created.

terraform {
  # Required Terraform CLI version for this project.
  # Choose a recent version that is compatible with the AWS provider.
  required_version = ">= 1.5.0, < 2.0.0"

  # The required_providers block lists the providers this project depends on.
  # Here, we use the AWS provider from HashiCorp's official registry.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider for the project.
provider "aws" {
  region = "ap-south-1"
}

# This data source fetches the availability zones in the selected region.
# We use it so the VPC subnets are spread across two AZs.
data "aws_availability_zones" "available" {
  state = "available"
}

# Main VPC for the application.
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "typing-speed-test-vpc"
  }
}

# Internet gateway allows resources in the public subnets to reach the internet.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "typing-speed-test-igw"
  }
}

# Public subnets for internet-facing resources such as a load balancer.
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "typing-speed-test-public-${count.index + 1}"
  }
}

# Private subnets for workloads like EKS worker nodes.
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "typing-speed-test-private-${count.index + 1}"
  }
}

# Public route table with a default route to the internet gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "typing-speed-test-public-rt"
  }
}

# Associate the public subnets with the public route table.
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route table for internal-only traffic.
# This is kept simple and can later be extended with a NAT gateway if needed.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "typing-speed-test-private-rt"
  }
}

# Associate the private subnets with the private route table.
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Output the key networking values for later use in EKS or other modules.
output "vpc_id" {
  description = "The ID of the VPC created for this project."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table."
  value       = aws_route_table.private.id
}
