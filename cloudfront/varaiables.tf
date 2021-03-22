variable "region_id" {}
variable "domain_name" {
  type = string
}
variable "lambda_arn" {
  type = map(string)
}
variable "aem_elb_domain" {
  type = map(string)
}
variable "aem_elb_origin_id" {
  type = map(string)
}
variable "aem_s3_domain" {
  type = map(string)
}
variable "aem_s3_origin_id" {
  type = map(string)
}
variable "aem_s3_default_origin_id" {
  type = map(string)
}
variable "origin_access_identity" {
  type = map(string)
}
variable "acm_certificate_arn" {
  type = map(string)
}
