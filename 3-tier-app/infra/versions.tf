terraform {
  required_version = "1.14.7"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket = "state-bucket-123456799"
    key = "eks-may-2026/3-tier-app/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}   