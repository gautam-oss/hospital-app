variable "project" {
  type = string
}
variable "env" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "backend_sg_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "public_ip" {
  type    = bool
  default = false
}
variable "asg_desired" {
  type    = number
  default = 1
}
variable "asg_min" {
  type    = number
  default = 1
}
variable "asg_max" {
  type    = number
  default = 3
}
variable "database_url" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type      = string
  sensitive = true
}
variable "repo_url" {
  type    = string
  default = "https://github.com/gautam-oss/hospital-app.git"
}
