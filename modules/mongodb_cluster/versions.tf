terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
  required_version = ">= 0.13"
}
