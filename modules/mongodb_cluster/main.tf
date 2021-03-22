locals {
  cluster_name           = length(var.cluster_name) > 0 ? var.cluster_name : "${var.app_name}-${var.mongodbatlas_project_name}"
  kubernetes_namespace   = length(var.kubernetes_namespace) > 0 ? var.kubernetes_namespace : var.app_name
  kubernetes_secret_name = length(var.app_name) > 0 ? "${var.app_name}-mongodb-credentials" : "mongodb-credentials"
}

# Fetch MongoDB Atlas project ID
data "mongodbatlas_project" "target" {
  name = var.mongodbatlas_project_name
}

# Create MongoDB cluster
resource "mongodbatlas_cluster" "main" {
  project_id   = data.mongodbatlas_project.target.id
  name         = local.cluster_name
  cluster_type = var.cluster_type
  replication_specs {
    num_shards = var.num_shards
    regions_config {
      region_name     = var.region # https://docs.atlas.mongodb.com/reference/microsoft-azure/
      electable_nodes = var.electable_nodes
      priority        = var.region_priority
      read_only_nodes = var.read_only_nodes
    }
  }
  provider_backup_enabled      = var.provider_backup_enabled
  auto_scaling_disk_gb_enabled = var.auto_scaling_disk_gb_enabled
  mongo_db_major_version       = var.mongo_db_major_version

  # Azure specific settings
  # https://docs.atlas.mongodb.com/reference/api/clusters-create-one/#request-body-parameters
  provider_name               = "AZURE"
  provider_disk_type_name     = var.provider_disk_type_name
  provider_instance_size_name = var.provider_instance_size_name
}

# Generate random password
resource "random_password" "database_user_password" {
  length           = 64
  special          = true
  override_special = "_%@"
}

# Create a database user
# https://docs.atlas.mongodb.com/reference/api/database-users-create-a-user/
resource "mongodbatlas_database_user" "default" {
  count              = var.create_database_user == true ? 1 : 0
  username           = var.database_user_name
  password           = length(var.database_user_password) > 0 ? var.database_user_password : random_password.database_user_password.result
  project_id         = data.mongodbatlas_project.target.id
  auth_database_name = var.database_user_auth_database_name

  dynamic "roles" {
    for_each = var.database_user_roles
    content {
      role_name     = roles.value["role_name"]
      database_name = roles.value["database_name"]
    }
  }

  dynamic "scopes" {
    for_each = var.database_user_scopes
    content {
      name = mongodbatlas_cluster.main.name
      type = scopes.value["type"]
    }
  }
}

# Provision db credentials and connection information in Kubernetes cluster
resource "kubernetes_secret" "mongodb_credentials" {
  count = var.kubernetes_create_secret == true ? 1 : 0
  metadata {
    name      = local.kubernetes_secret_name
    namespace = local.kubernetes_namespace
    labels    = var.labels
  }

  data = local.kubernetes_secret_data
}