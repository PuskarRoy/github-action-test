provider "aws" {

  region = var.aws_region

  default_tags {
    tags = {
      Terraform = "Yes"
    }
  }
}

provider "random" {}

provider "tls" {}