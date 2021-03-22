# ALB Step 0
resource "aws_alb" "alb" {
  name            = "aem-instance-alb"
  subnets         = var.vpc_id
  security_groups = [var.alb_security_groups]
  internal        = false
  tags            = {
    Name     = "aem-instance-alb"
    PURPOSE  = "aem"
    CREATOR  = "Terraform"
  }
}
# ALB Step 1 HTTP
resource "aws_alb_target_group" "aem_tg" {
  name     = "aem-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.subnet_prefixes[0]
}


# # ALB Step 2 HTTP
# resource "aws_alb_target_group_attachment" "aem_tga" {
#   target_group_arn = aws_alb_target_group.aem_tg.arn
#   target_id        = aws_instance.aem.id
#   port             = 80
# }

# # ALB Step 3 HTTP
# # Create a new application load balancer listener for HTTP.
# resource "aws_alb_listener" "aem_listener" {
#   load_balancer_arn = aws_alb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.aem_tg.arn
#     type             = "forward"
#   }
# }

# # Create a new application load balancer listener for HTTPS.
# resource "aws_alb_listener" "listener_https" {
#   load_balancer_arn = aws_alb.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.alb_certificate_arn

#   default_action {
#     target_group_arn = aws_alb_target_group.aem_tg.arn
#     type             = "forward"
#   }
# }

# # certificate for example.com
# resource "aws_lb_listener_certificate" "listener_certificate_etrvls" {
#   listener_arn    = aws_alb_listener.listener_https.arn
#   certificate_arn = var.example_alb_certificate_arn
# }
