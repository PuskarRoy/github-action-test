terraform {
  required_version = "~> 1.13"

  backend "s3" {
    bucket = "terraform-state-s3-bucket-388458311239"
    key    = "state/terraform.tfstate"
    region = "ap-south-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.2"
    }

  }
}