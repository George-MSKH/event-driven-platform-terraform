output "elb_sg_id" {
  value = aws_security_group.elb.id
}

output "app_sg_id" {
  value = aws_security_group.private_app_sg.id
}

output "db_sg_id" {
  value = aws_security_group.private_db_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}