resource "aws_security_group" "elb" {
  name = "elb-sg"
  vpc_id = var.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "elb_http" {
    security_group_id = aws_security_group.elb.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "elb_https" {
    security_group_id = aws_security_group.elb.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "elb_egress" {
    security_group_id = aws_security_group.elb.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = -1
}

resource "aws_security_group" "private_app_sg" {
    name = "private-app-sg"
    vpc_id = var.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "private_app_ingress_http" {
    security_group_id = aws_security_group.private_app_sg.id
    referenced_security_group_id = aws_security_group.elb.id

    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "private_app_egress" {
    security_group_id = aws_security_group.private_app_sg.id

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_security_group" "private_db_sg" {
  name = "private-db-sg"
  vpc_id = var.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "private_db_ingress" {
    security_group_id = aws_security_group.private_db_sg.id
    referenced_security_group_id = aws_security_group.private_app_sg.id

    from_port = 3306
    to_port = 3306
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "private_db_egress" {
  security_group_id = aws_security_group.private_db_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "bastion_sg" {
  name = "elb-sg"
  vpc_id = var.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
    security_group_id = aws_security_group.bastion

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "bastion_ssh_egress" {
    security_group_id = aws_security_group.bastion

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}