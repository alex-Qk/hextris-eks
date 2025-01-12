output "azs" {
  description = "A list of availability zones"
  value       = module.vpc.azs
}

output "name" {
  description = "VPC name"
  value       = module.vpc.name
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = module.vpc.database_subnets
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.vpc.database_subnet_group_name
}

output "database_subnets_cidr_blocks" {
  description = "List of database subnet CIDR blocks"
  value       = module.vpc.database_subnets_cidr_blocks
}

output "elasticache_subnets" {
  description = "List of elasticache subnet IDs"
  value       = module.vpc.elasticache_subnets
}

output "elasticache_subnets_cidr_blocks" {
  description = "List of elasticache subnet CIDR blocks"
  value       = module.vpc.elasticache_subnets_cidr_blocks
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = module.vpc.intra_subnets
}

output "intra_subnets_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = module.vpc.intra_subnets_cidr_blocks
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
