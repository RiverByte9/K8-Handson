terraform {
  required_version = "1.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket       = "state-bucket-987653211"
    key          = "eks-may-2026/eks-core-cluster/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}