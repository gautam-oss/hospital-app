variable "project" {
  type = string
}
variable "env" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {
  type = string
}
variable "db_instance_class" {
  type = string
}
variable "db_storage" {
  type    = number
  default = 20
}
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type      = string
  sensitive = true
}
