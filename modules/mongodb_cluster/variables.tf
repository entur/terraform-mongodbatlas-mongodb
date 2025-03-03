# Most MongoDB Atlas specific variables should match those used as provider supported resource attributes.
# For more information on what they do, see the official docs:
# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cluster

variable "app_name" {
  type    = string
  default = ""
}

variable "mongodbatlas_project_name" {
  type = string
}

variable "cluster_name" { # Note: a cluster cannot be renamed post creation
  type    = string
  default = ""
}

variable "kubernetes_namespace" {
  type    = string
  default = ""
}

variable "kubernetes_create_secret" {
  type    = bool
  default = true
}

variable "create_database_user" {
  type    = bool
  default = true
}

variable "cluster_type" {
  type    = string
  default = "REPLICASET"
}

variable "region" {
  description = "Unknown region, please use a region listed here: https://docs.atlas.mongodb.com/reference/microsoft-azure/"
  type        = string
  default     = "NORWAY_EAST"
}

variable "provider_disk_type_name" {
  description = "Unknown disk type, please use a disk type listed here: https://docs.atlas.mongodb.com/reference/api/clusters-create-one/#request-body-parameters"
  type        = string
  default     = "P2"
}

variable "provider_instance_size_name" {
  type    = string
  default = "M10"
}

variable "mongo_db_major_version" {
  type    = string
  default = "4.4"
}

variable "num_shards" {
  type    = number
  default = 1
}

variable "electable_nodes" {
  type    = number
  default = 3
}

variable "region_priority" {
  type    = number
  default = 7
}

variable "read_only_nodes" {
  type    = number
  default = 0
}

variable "provider_backup_enabled" {
  type    = bool
  default = true
}

variable "auto_scaling_disk_gb_enabled" {
  type    = bool
  default = true
}

variable "database_user_name" {
  type    = string
  default = "mongouser"
}

variable "database_user_password" {
  type    = string
  default = ""
}

variable "database_user_auth_database_name" {
  type    = string
  default = "admin"
}

variable "database_user_roles" {
  type = map(any)
  default = {
    readWriteAnyDatabase = {
      role_name     = "readWriteAnyDatabase"
      database_name = "admin"
    }
  }
}

variable "database_user_scopes" {
  type = map(any)
  default = {
    cluster = {
      type = "CLUSTER"
    }
  }
}

variable "labels" {
  type    = map(any)
  default = {}
}
