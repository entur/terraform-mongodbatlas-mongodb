output "project_id" {
  value = data.mongodbatlas_project.target.id
}

output "cluster_id" {
  value = mongodbatlas_cluster.main.id
}

output "cluster_name" {
  value = mongodbatlas_cluster.main.name
}

output "connection_string_privatelink" {
  value = try(mongodbatlas_cluster.main.connection_strings[0].private_endpoint[0].connection_string, "")
}

output "connection_string_privatelink_srv" {
  value = try(mongodbatlas_cluster.main.connection_strings[0].private_endpoint[0].srv_connection_string, "")
}

output "connection_string_standard" {
  value = mongodbatlas_cluster.main.connection_strings[0].standard
}

output "connection_string_standard_srv" {
  value = mongodbatlas_cluster.main.connection_strings[0].standard_srv
}

output "nodes_privatelink" {
  value = local.nodes_privatelink
}

output "nodes_standard" {
  value = local.nodes_standard
}
