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
variable "private_subnet_ids" {
  type = list(string)
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
