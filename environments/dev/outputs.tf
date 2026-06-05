output "frontend_url" { value = module.frontend.website_url }
output "db_endpoint"  { value = module.database.db_endpoint }

output "db_password_arn" { value = module.secrets.db_password_arn }
output "jwt_secret_arn"  { value = module.secrets.jwt_secret_arn }
