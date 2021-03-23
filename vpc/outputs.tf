
output "vpc_arn" {
  value = aws_vpc.aem-vpc.arn
}
output "vpc_id" {
  value = aws_vpc.aem-vpc.id
}
output "public_subnet_one" {
  value = aws_subnet.aem-subnet-public-1a.id
}

output "private_subnet_one" {
  value = aws_subnet.aem-subnet-private-1a.id
}

output "private_subnet_two" {
  value = aws_subnet.aem-subnet-private-1c.id
}

