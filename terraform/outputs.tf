output "public_subnet_a_id" {
  value = module.vpc.public_subnet_ids[0]
}

output "public_subnet_b_id" {
  value = module.vpc.public_subnet_ids[1]
}

output "private_subnet_a_id" {
  value = module.vpc.private_subnet_ids[0]
}

output "private_subnet_b_id" {
  value = module.vpc.private_subnet_ids[1]
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}
