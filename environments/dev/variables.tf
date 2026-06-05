variable "project" {
  type    = string
  default = "mysaas"
}
variable "ami_id" {
  type    = string
  default = "ami-0f58b397bc5c1f2e8"
}
variable "db_name" {
  type    = string
  default = "mysaas_dev"
}
variable "db_username" {
  type    = string
  default = "dbadmin"
}
variable "db_password" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}
