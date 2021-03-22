 provider "aws" {
   region = "us-east-1"
 }


resource "aws_vpc" "aem-vpc" {
  cidr_block = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "aem-vpc"
    Environment = "aem"
    Creator = "Terraform"
  }
}

# create the private Subnet
resource "aws_subnet" "aem-subnet-private-1a" {
  vpc_id                  = aws_vpc.aem-vpc.id
  cidr_block              = var.subnet_one_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "aem-subnet-private-1a"
    Creator = "Terraform"
  }
}
# create the private Subnet
resource "aws_subnet" "aem-subnet-private-1c" {
  vpc_id                  = aws_vpc.aem-vpc.id
  cidr_block              = var.subnet_three_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"
  tags = {
    Name = "aem-subnet-private-1c"
    Creator = "Terraform"
  }
}

# create the public Subnet
resource "aws_subnet" "aem-subnet-public-1a" {
  vpc_id                  = aws_vpc.aem-vpc.id
  cidr_block              = var.subnet_two_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "aem-subnet-public-1a"
    Creator = "Terraform"
  }
  depends_on = [aws_subnet.aem-subnet-private-1a]
}

# create the public Subnet
resource "aws_subnet" "aem-subnet-public-1c" {
  vpc_id                  = aws_vpc.aem-vpc.id
  cidr_block              = var.subnet_four_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"
  tags = {
    Name = "aem-subnet-public-1c"
    Creator = "Terraform"
  }
  depends_on = [aws_subnet.aem-subnet-private-1c]
}

# Create the Security Group
resource "aws_security_group" "aem-sg-default" {
  vpc_id       = aws_vpc.aem-vpc.id
  name         = "aem-default"
  description  = "aem-default"
  
  tags = {
    Name = "aem-sg-default"
    Description = "aem-sg-default"
    Creator = "Terraform"
  }
} 

resource "aws_security_group_rule" "aem-default-inbound-rule" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.aem-vpc.cidr_block]
  security_group_id = aws_security_group.aem-sg-default.id
}

resource "aws_security_group_rule" "aem-default-outbound-sg-rule" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aem-sg-default.id
}

# create VPC Network access control list
resource "aws_network_acl" "aem-acl-default" {
  vpc_id = aws_vpc.aem-vpc.id
  # subnet_ids = [ aws_subnet.My_VPC_Subnet.id ]

  # allow ingress port All
  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0" 
    from_port  = 0 
    to_port    = 0 
  }
  
  # allow egress port All 
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0" 
    from_port  = 0 
    to_port    = 0 
  }
  
  tags = {
    Name = "aem-default-acl"
    Creator = "Terraform"
  }
} 

resource "aws_internet_gateway" "aem-igw" {
  vpc_id = aws_vpc.aem-vpc.id
  tags = {
    Name = "aem-igw"
    Environment = "aem internet gateway"
    Creator = "Terraform"
  }
}

resource "aws_route_table" "aem-rtb-ig" {
  vpc_id = aws_vpc.aem-vpc.id
  tags = {
    Name = "aem-rtb"
    Creator = "Terraform"
  }
}

resource "aws_eip" "aem-eip" {
  vpc      = true
  tags = {
    Name = "aem-eip"
    Creator = "Terraform"
  }
}

resource "aws_nat_gateway" "aem-nat-gateway" {
  allocation_id = aws_eip.aem-eip.id
  subnet_id     = aws_subnet.aem-subnet-public-1a.id
  tags = {
    Name = "aem-nat"
    Environment = "aem NAT gateway"
    Creator = "Terraform"
  }
}

resource "aws_route" "aem-route-internet-gateway" {
  route_table_id         = aws_vpc.aem-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aem-igw.id
}

resource "aws_route" "aem-route-nat-gateway" {
  route_table_id         = aws_route_table.aem-rtb-ig.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aem-nat-gateway.id
}


# Associate the Route Table with the Subnet
resource "aws_route_table_association" "aem-rtba-private-1a" {
  subnet_id = aws_subnet.aem-subnet-private-1a.id
  route_table_id = aws_route_table.aem-rtb-ig.id
}
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "aem-rtba-private-1c" {
  subnet_id = aws_subnet.aem-subnet-private-1c.id
  route_table_id = aws_route_table.aem-rtb-ig.id
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "aem-rtba-public-1a" {
  subnet_id = aws_subnet.aem-subnet-public-1a.id
  route_table_id = aws_vpc.aem-vpc.main_route_table_id
}
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "aem-rtba-public-1c" {
  subnet_id = aws_subnet.aem-subnet-public-1c.id
  route_table_id = aws_vpc.aem-vpc.main_route_table_id
}
