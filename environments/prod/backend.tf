terraform {
  backend "s3" {
    bucket         = "tf-state-prod-208179291544"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks-prod"
    encrypt        = true
  }
}
