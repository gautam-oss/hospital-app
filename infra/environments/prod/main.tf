terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  backend "s3" {
    bucket         = "tf-state-prod-208179291544"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks-prod"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "networking" {
  source               = "../../modules/networking"
  project              = var.project
  env                  = "prod"
  vpc_cidr             = "10.2.0.0/16"
  public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
  private_subnet_cidrs = ["10.2.10.0/24", "10.2.11.0/24"]
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  app_port             = 8080
}

module "frontend" {
  source     = "../../modules/frontend"
  project    = var.project
  env        = "prod"
  enable_cdn = true
}

module "loadbalancer" {
  source            = "../../modules/loadbalancer"
  project           = var.project
  env               = "prod"
  alb_sg_id         = module.networking.alb_sg_id
  public_subnet_ids = module.networking.public_subnet_ids
  vpc_id            = module.networking.vpc_id
  app_port          = 8080
}

module "database" {
  source             = "../../modules/database"
  project            = var.project
  env                = "prod"
  private_subnet_ids = module.networking.private_subnet_ids
  rds_sg_id          = module.networking.rds_sg_id
  db_instance_class  = "db.t3.small"
  db_storage         = 100
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

module "backend" {
  source        = "../../modules/backend"
  project       = var.project
  env           = "prod"
  ami_id        = var.ami_id
  instance_type = "t3.medium"
  backend_sg_id = module.networking.backend_sg_id
  subnet_ids    = module.networking.private_subnet_ids
  public_ip     = false
  asg_desired   = 2
  asg_min       = 2
  asg_max       = 10
  database_url  = "postgresql://${var.db_username}:${var.db_password}@${module.database.db_endpoint}/${var.db_name}"
  secret_key    = var.jwt_secret
  repo_url      = "https://github.com/gautam-oss/hospital-app.git"
}

module "monitoring" {
  source  = "../../modules/monitoring"
  project = var.project
  env     = "prod"
}

module "secrets" {
  source      = "../../modules/secrets"
  project     = var.project
  env         = "prod"
  db_password = var.db_password
  jwt_secret  = var.jwt_secret
}
