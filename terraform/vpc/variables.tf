variable "region" {
  type        = string
  description = "Default region"
  default     = "eu-west-2"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.101.0.0/16"
}

variable "name" {
  type        = string
  description = "VPC name"
  default     = "training-vpc"
}
