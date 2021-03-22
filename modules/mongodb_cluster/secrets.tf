# Construct connection data and credentials for both standard and privatelink connections
#
# Example privatelink connection string
# mongodb://pl-0-norwayeast-azure.xlpui.mongodb.net:1027,pl-0-norwayeast-azure.xlpui.mongodb.net:1028,pl-0-norwayeast-azure.xlpui.mongodb.net:1029/?ssl=true&authSource=admin&replicaSet=atlas-w8q8d5-shard-0

locals {
  # Split standard connection string
  connection_strings_standard = split(
    ",",
    replace(
      split(
        "/?",
        mongodbatlas_cluster.main.connection_strings[0].standard,
      )[0],
      "mongodb://",
      ""
    )
  )

  # Split private link aware connection string
  connection_strings_privatelink = split(
    ",",
    replace(
      split(
        "/?",
        mongodbatlas_cluster.main.connection_strings[0].private_endpoint[0].connection_string,
      )[0],
      "mongodb://",
      ""
    )
  )

  # Split and sort hosts vs. ports
  nodes_standard = flatten([
    for node in local.connection_strings_standard : {
      host = split(":", node)[0],
      port = split(":", node)[1],
    }
  ])

  nodes_privatelink = flatten([
    for node in local.connection_strings_privatelink : {
      host = split(":", node)[0],
      port = split(":", node)[1],
    }
  ])

  # Standard set of Kubernetes secret data
  kubernetes_secret_data_defaults = {
    MONGODB_USERNAME    = try(mongodbatlas_database_user.default[0].username, "")
    MONGODB_PASSWORD    = try(mongodbatlas_database_user.default[0].password, "")
    MONGODB_CONNSTR     = mongodbatlas_cluster.main.connection_strings[0].standard
    MONGODB_CONNSTR_SRV = mongodbatlas_cluster.main.connection_strings[0].standard_srv
    MONGODB_HOST0       = try(local.nodes_standard[0].host, "")
    MONGODB_PORT0       = try(local.nodes_standard[0].port, 0)
    MONGODB_HOST1       = try(local.nodes_standard[1].host, "")
    MONGODB_PORT1       = try(local.nodes_standard[1].port, 0)
    MONGODB_HOST2       = try(local.nodes_standard[2].host, "")
    MONGODB_PORT2       = try(local.nodes_standard[2].port, 0)
    MONGODB_HOST3       = try(local.nodes_standard[3].host, "")
    MONGODB_PORT3       = try(local.nodes_standard[3].port, 0)
    MONGODB_HOST4       = try(local.nodes_standard[4].host, "")
    MONGODB_PORT4       = try(local.nodes_standard[4].port, 0)
    MONGODB_HOST5       = try(local.nodes_standard[5].host, "")
    MONGODB_PORT5       = try(local.nodes_standard[5].port, 0)
  }

  # Data appended to secret if privatelink is available
  kubernetes_secret_nodes_privatelink = length(mongodbatlas_cluster.main.connection_strings[0].private_endpoint) > 0 ? {
    MONGODB_CONNSTR_PRIVATELINK     = try(mongodbatlas_cluster.main.connection_strings[0].private_endpoint[0].connection_string, "")
    MONGODB_CONNSTR_PRIVATELINK_SRV = try(mongodbatlas_cluster.main.connection_strings[0].private_endpoint[0].srv_connection_string, "")
    MONGODB_HOST0_PRIVATELINK       = try(local.nodes_privatelink[0].host, "")
    MONGODB_PORT0_PRIVATELINK       = try(local.nodes_privatelink[0].port, "")
    MONGODB_HOST1_PRIVATELINK       = try(local.nodes_privatelink[1].host, "")
    MONGODB_PORT1_PRIVATELINK       = try(local.nodes_privatelink[1].port, "")
    MONGODB_HOST2_PRIVATELINK       = try(local.nodes_privatelink[2].host, "")
    MONGODB_PORT2_PRIVATELINK       = try(local.nodes_privatelink[2].port, "")
    MONGODB_HOST3_PRIVATELINK       = try(local.nodes_privatelink[3].host, "")
    MONGODB_PORT3_PRIVATELINK       = try(local.nodes_privatelink[3].port, "")
    MONGODB_HOST4_PRIVATELINK       = try(local.nodes_privatelink[4].host, "")
    MONGODB_PORT4_PRIVATELINK       = try(local.nodes_privatelink[4].port, "")
    MONGODB_HOST5_PRIVATELINK       = try(local.nodes_privatelink[5].host, "")
    MONGODB_PORT5_PRIVATELINK       = try(local.nodes_privatelink[5].port, "")
  } : {}

  kubernetes_secret_data = merge(local.kubernetes_secret_data_defaults, local.kubernetes_secret_nodes_privatelink)
}