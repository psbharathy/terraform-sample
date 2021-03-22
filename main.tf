provider "aws" {
    region = "us-east-1"
}

module "aemvpc" {
  source = "./vpc/"
}

module "aem_ec2" {
  source = "./ec2/"
  vpc_id =  [module.aemvpc.vpc_id]
  subnet_prefixes = [module.aemvpc.public_subnet_one]
}

module "aem-alb" {
  source = "./loadBalancer/"
  vpc_id =  [module.aemvpc.vpc_id]
  subnet_prefixes = [module.aemvpc.public_subnet_one]
  depends_on=[module.aemvpc]
}


# module "aem-cloudfront" {
#   source = "./cloudfront/"
#   domain_name = ["example.com"]
#   vpc_id =  [module.aemvpc.vpc_id]
#   aem_elb_origin_id=[module.aem-alb.vpc_id]
#   subnet_prefixes = [module.aemvpc.public_subnet_one]
# }