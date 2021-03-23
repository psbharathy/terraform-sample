provider "aws" {
    region = "us-east-1"
}

module "aemvpc" {
  source = "./vpc/"
}

module "aem_ec2" {
  source = "./ec2/"
  subnet_private = [module.aemvpc.private_subnet_one, module.aemvpc.private_subnet_two]
  subnet_public = module.aemvpc.public_subnet_one
  depends_on=[module.aemvpc]

}

module "aem-alb" {
  source = "./loadBalancer/"
  vpc_id =  [module.aemvpc.vpc_id]
  subnet_prefixes = [module.aemvpc.public_subnet_one]
  subnet_private = module.aemvpc.private_subnet_one
  ec2_aem_dispatcher_one = module.aem_ec2.ec2_aem_dispatcher_one
  ec2_aem_dispatcher_two = module.aem_ec2.ec2_aem_dispatcher_two

  ec2_aem_author_dispatcher_one = module.aem_ec2.ec2_aem_author_dispatcher_node_one
  ec2_aem_author_dispatcher_two = module.aem_ec2.ec2_aem_author_dispatcher_node_two
  depends_on=[module.aemvpc, module.aem_ec2]
}

module "aem-cloudfront" {
  source = "./cloudfront/"
  domain_name = "example.com"
  aem_elb_name = module.aem-alb.aem_elb_name
  aem_elb_origin_id= module.aem-alb.aem_elb_origin_id
  depends_on=[module.aemvpc, module.aem-alb]
}
