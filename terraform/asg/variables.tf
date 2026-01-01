variable "image_id" {
  default = "ami-004e960cde33f9146"
}

variable "private_app_subnet" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "target_group" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "public_sg" {
  type = list(string)
}

variable "app_instance_profile_name" {
  type = string
}

variable "worker_instance_profile" {
  type = string
}