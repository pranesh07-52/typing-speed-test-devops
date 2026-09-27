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

# Notes:
# - This is only the setup block.
# - No AWS resources such as EC2, S3, or VPC are created here yet.
# - We will add resources later once the project is ready to deploy infrastructure.
