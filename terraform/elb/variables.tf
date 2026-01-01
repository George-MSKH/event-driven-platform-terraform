variable "security_group" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc" {
  type = string
}