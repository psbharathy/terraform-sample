resource "aws_instance" "aem_dispatcher" {
  ami                         = var.dispatcher_ami_id
  instance_type               = "t2.micro"

  count = var.instances_per_subnet * length(var.subnet_private)
  subnet_id  = count.index % length(var.subnet_private)
  vpc_security_group_ids   = [var.vpc_security_group_id]
  associate_public_ip_address	= false

  tags = {
    Name = "AEM Dispatcher"
    Purpose  = "Dispatcher"
    Creator  = "Terraform"
  }
}

resource "aws_instance" "aem_bastion" {
  ami                         = var.ami_bastion
  instance_type               = "t2.micro"
  subnet_id                   =  var.subnet_public
  vpc_security_group_ids      = [var.vpc_security_group_id]
  associate_public_ip_address	= true

  tags = {
    Name = "AEM Bastion"
    Purpose  = "Bastion"
    Creator  = "Terraform"
  }
}

resource "aws_instance" "aem_publisher" {
  ami                         = var.publisher_ami_id
  instance_type               = "t2.micro"

  count = var.instances_per_subnet * length(var.subnet_private)
  subnet_id  = count.index % length(var.subnet_private)
  vpc_security_group_ids   = [var.vpc_security_group_id]
  associate_public_ip_address	= false

  tags = {
    Name = "AEM Publisher"
    Purpose  = "Publisher"
    Creator  = "Terraform"
  }
}

resource "aws_instance" "aem_author" {
  ami                         = var.author_ami_id
  instance_type               = "t2.micro"
  count = var.instances_per_subnet * length(var.subnet_private)
  subnet_id  = count.index % length(var.subnet_private)

  vpc_security_group_ids   = [var.vpc_security_group_id]
  associate_public_ip_address	= false

  tags = {
    Name = "AEM Author"
    Purpose  = "Publisher"
    Creator  = "Terraform"
  }
#   depends_on = []
}

resource "aws_instance" "aem_author_dispatcher" {
  ami                         = var.author_dispatcher_ami_id
  instance_type               = "t2.micro"

  count = var.instances_per_subnet * length(var.subnet_private)
  subnet_id  = count.index % length(var.subnet_private)

  vpc_security_group_ids   = [var.vpc_security_group_id]
  associate_public_ip_address	= false

  tags = {
    Name = "AEM Author Dispatcher"
    Purpose  = "Author Dispatcher"
    Creator  = "Terraform"
  }
}