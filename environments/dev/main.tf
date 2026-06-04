terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  backend "s3" {
    bucket         = "tf-state-dev-208179291544"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks-dev"
    encrypt        = true
    profile        = "dev"
  }
}
provider "aws" {
  region  = "ap-south-1"
  profile = "dev"
}
module "networking" {
  source               = "../../modules/networking"
  project              = var.project
  env                  = "dev"
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  app_port             = 8080
}
module "frontend" {
  source     = "../../modules/frontend"
  project    = var.project
  env        = "dev"
  enable_cdn = false
}
module "backend" {
  source             = "../../modules/backend"
  project            = var.project
  env                = "dev"
  ami_id             = var.ami_id
  instance_type      = "t3.micro"
  backend_sg_id      = module.networking.backend_sg_id
  private_subnet_ids = module.networking.private_subnet_ids
  asg_desired        = 1
  asg_min            = 1
  asg_max            = 2
}
module "database" {
  source             = "../../modules/database"
  project            = var.project
  env                = "dev"
  private_subnet_ids = module.networking.private_subnet_ids
  rds_sg_id          = module.networking.rds_sg_id
  db_instance_class  = "db.t3.micro"
  db_storage         = 20
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}
