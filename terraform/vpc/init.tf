terraform {
  backend "s3" {
    bucket = "terraform-state-304643094051"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}
