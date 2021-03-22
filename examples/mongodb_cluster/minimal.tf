provider "mongodbatlas" {}
provider "kubernetes" {}

module "mongodb" {
  source                    = "../../modules/terraform-mongodbatlas-mongodb/modules/mongodb_cluster"
  mongodbatlas_project_name = "my-mongodbatlas-project"
  app_name                  = "my-app"
}