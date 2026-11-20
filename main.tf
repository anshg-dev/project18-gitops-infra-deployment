terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "gitops_demo" {
  bucket = "project18-gitops-demo-${random_id.bucket_suffix.hex}"

  tags = {
    Project     = "Project18-GitOps"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "gitops_demo" {
  bucket = aws_s3_bucket.gitops_demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.gitops_demo.bucket
}
