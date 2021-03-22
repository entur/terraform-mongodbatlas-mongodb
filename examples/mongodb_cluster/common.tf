provider "mongodbatlas" {}
provider "kubernetes" {}

module "mongodb" {
  source                       = "../../modules/terraform-mongodbatlas-mongodb/modules/mongodb_cluster"
  mongodbatlas_project_name    = "my-mongodbatlas-project"
  app_name                     = "my-app"
  region                       = "NORWAY_EAST"
  provider_disk_type_name      = "P2"
  provider_instance_size_name  = "M10"
  mongo_db_major_version       = "4.4"
  provider_backup_enabled      = true
  auto_scaling_disk_gb_enabled = true
  database_user_name           = "appuser"
}