output "elb_id" {
  value       = aws_lb.web.id
  description = "The ID of the ELB"
}

output "elb_arn" {
  value       = aws_lb.web.arn
  description = "The ARN of the ELB"
}

output "elb_dns_name" {
  value       = aws_lb.web.dns_name
  description = "The DNS name of the ELB"
}

output "elb_security_group_id" {
  value       = aws_security_group.elb.id
  description = "Security group attached to the ELB"
}

output "target_group_arn" {
  value = aws_lb_target_group.elb-tgp.id
}