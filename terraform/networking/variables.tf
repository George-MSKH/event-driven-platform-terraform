variable "specific_vpc_cidr" {
  default = "10.0.0.0/16"
  type = string
}

variable "public_subnet_cidr" {
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
  type = list(string)
}

variable "private_subnet_db_cidr" {
  default = [ "10.0.101.0/24", "10.0.102.0/24" ]
  type = list(string)
}

variable "private_subnet_app_cidr" {
  default = [ "10.0.103.0/24", "10.0.104.0/24" ]
  type = list(string)
}

variable "azs" {
  default = [ "eu-central-1a", "eu-central-1b" ]
  type = list(string)
}