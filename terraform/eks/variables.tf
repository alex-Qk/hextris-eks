variable "region" {
  type        = string
  description = "Default region"
  default     = "eu-west-2"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.28"
}

variable "name" {
  type        = string
  description = "Cluster name"
  default     = "training_eks"
}

variable "kubernetes_public_key" {
  type        = string
  description = "Public SSH key for accessing EC2 instances in the node groups"
  default     = "ssh-rsa REDACTED"
}
