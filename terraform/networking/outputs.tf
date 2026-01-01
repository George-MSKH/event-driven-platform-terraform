output "vpc_id" {
  value = aws_vpc.specific_vpc_cidr.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets_app_id" {
  value = aws_subnet.private_subnets_app[*].id
}

output "private_subnets_db_id" {
  value = aws_subnet.private_subnets_db[*].id
}