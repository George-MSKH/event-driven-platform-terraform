module "vpc" {
  source = "./networking"
  specific_vpc_cidr = "10.0.0.0/16"
}

module "sg" {
  source = "./security-groups"
  vpc = module.vpc.vpc_id
}