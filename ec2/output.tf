output "ec2_aem_dispatcher_node" {
  value = aws_instance.aem_dispatcher
}

output "ec2_aem_publisher_node" {
  value = aws_instance.aem_publisher
}

output "ec2_aem_author_node" {
  value = aws_instance.aem_author
}

output "ec2_aem_author_dispatcher_node" {
  value = aws_instance.aem_author_dispatcher
}