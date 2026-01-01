module "vpc" {
  source = "./networking"
  specific_vpc_cidr = "10.0.0.0/16"
}

module "sg" {
  source = "./security-groups"
  vpc = module.vpc.vpc_id
}

module "iam" {
  source = "./iam"
}

module "asg" {
  source = "./asg"
  private_app_subnet = module.vpc.private_subnets_app_id
  security_group = [module.sg.app_sg_id]
  public_sg = [module.sg.bastion_sg_id]
  target_group = module.elb.target_group_arn
  public_subnets = [module.vpc.public_subnets_id]
  app_instance_profile_name = module.iam.app_instance_profile_name
  worker_instance_profile = module.iam.worker_instance_profile_name
}

module "elb" {
  source = "./elb"
  security_group = [module.sg.elb_sg_id]
  public_subnets = [module.vpc.public_subnets_id]
  vpc = module.vpc.vpc_id
}