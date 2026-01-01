resource "aws_launch_template" "asg_lt" {
  name = "asg-lt"
  image_id = var.image_id
  instance_type = "t3.micro"
  key_name = "lab-key"

  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance_profile_name
  }

  network_interfaces {
    security_groups = var.security_group
    associate_public_ip_address = false
  }
}

resource "aws_autoscaling_group" "asg_autoscaling" {
  name = "web-asg"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  vpc_zone_identifier = var.private_app_subnet

  launch_template {
    id = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group]
  health_check_type = "ELB"
  health_check_grace_period = 300

  tag {
    key = "name"
    value = "web-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_instance" "bastion" {
  ami = var.image_id
  instance_type = "t3.micro"
  subnet_id = var.public_subnets[0]
  vpc_security_group_ids = var.public_sg
  key_name = "lab-key"
  associate_public_ip_address = true

  tags = {
    Name = "Bastion_ec2"
  }
}


// worker asg below


resource "aws_launch_template" "worker_lt" {
  name = "worker-lt"
  image_id = var.image_id
  instance_type = "t3.micro"
  key_name = "lab-key"

  iam_instance_profile {
    name = aws_iam_instance_profile.worker_instance_profile
  }

  network_interfaces {
    security_groups = [aws_security_group.private_app_sg.id]
    associate_public_ip_address = false
  }
}

resource "aws_autoscaling_group" "worker_asg" {
  name                 = "worker-asg"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 2
  vpc_zone_identifier  = var.private_app_subnet

  launch_template {
    id      = aws_launch_template.worker_lt.id
    version = "$Latest"
  }

  health_check_type          = "EC2"
  health_check_grace_period  = 300

  tag {
    key                 = "Name"
    value               = "worker-instance"
    propagate_at_launch = true
  }
}
