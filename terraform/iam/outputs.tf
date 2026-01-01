output "app_role_id" {
  value       = aws_iam_role.ec2_app_role.id
  description = "ID of the App EC2 IAM role"
}

output "worker_role_id" {
  value       = aws_iam_role.ec2_worker_role.id
  description = "ID of the Worker EC2 IAM role"
}

output "app_instance_profile_name" {
  value       = aws_iam_instance_profile.app_instance_profile.name
  description = "Instance profile name for app EC2s"
}

output "worker_instance_profile_name" {
  value       = aws_iam_instance_profile.worker_instance_profile.name
  description = "Instance profile name for worker EC2s"
}
