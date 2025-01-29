module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = var.name
  cidr = var.cidr

  # https://www.terraform.io/language/functions/cidrsubnet
  azs                 = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets     = [for i in [0, 1, 2] : cidrsubnet(var.cidr, 4, i)]
  public_subnets      = [for i in [50, 51, 52] : cidrsubnet(var.cidr, 8, i)]
  database_subnets    = [for i in [60, 61, 62] : cidrsubnet(var.cidr, 8, i)]
  elasticache_subnets = [for i in [70, 71, 72] : cidrsubnet(var.cidr, 8, i)]
  intra_subnets       = [for i in [1280, 1281, 1282] : cidrsubnet(var.cidr, 12, i)]

  create_database_subnet_group    = true
  create_elasticache_subnet_group = true
  create_redshift_subnet_group    = false

  map_public_ip_on_launch    = true
  enable_nat_gateway         = true
  single_nat_gateway         = true
  enable_dns_hostnames       = true
  manage_default_network_acl = true

  public_subnet_tags = {
    "SubnetType"                         = "Public"
    "kubernetes.io/cluster/training_eks" = "shared"
    "kubernetes.io/role/alb-ingress"     = "1"
    "kubernetes.io/role/elb"             = "1"
  }

  private_subnet_tags = {
    "SubnetType"                         = "Private"
    "kubernetes.io/cluster/training_eks" = "shared"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/role/alb-ingress"     = "1"
  }

  tags = local.tags
}
