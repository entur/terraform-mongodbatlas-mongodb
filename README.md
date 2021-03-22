# MongoDB Atlas cluster module

A module for creating clusters on MongoDB Atlas, deployed to Azure.

* Supports privatelink endpoint connections
* Splits connection strings for compatibility with different implementations and drivers
* Creates a database user with roles, scoped to the cluster by default
* Creates a Kubernetes secret containing connection strings and credentials

## Requirements
Your root module should be configured to use these providers:
* `mongodbatlas` [[docs](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs)]
* `kubernetes` [[docs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)]

## Getting started
Common attributes can be configured using the variables listed under [Inputs](#Inputs). Most variables should have sensible defaults that should help you get started.

### Notes on database user creation
The database user is scoped to the created cluster by default, with read/write access to any database and collection in it. Meaning it can only access the cluster created by this module, and not other clusters in the same project.

**To grant the user access to all clusters in a project, omit the attribute by providing an empty map.**
```
module "mongodb" {
  [...]
  database_user_scopes = {}
  [...]
}
```

**To specify which roles a database user should have rather than use the default (read/write all databases), provide a map of scopes.**
```
module "mongodb" {
  [...]
  database_user_roles       = {
    fooReader = {
      role_name       = "read"
      database_name   = "foo"
      collection_name = "bar"
    }
  }
  [...]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app_name | Name of the application the cluster belongs to | string | N/A | yes |
| auto_scaling_disk_gb_enabled | Enable disk autoscaling | string | N/A | no |
| cluster_name | Name of the cluster | string | N/A | no |
| database_user_auth_database_name | Database user auth database | string | admin | no |
| database_user_name | Database user username | string | mongouser | no |
| database_user_password | Database user password | string | Generated | no |
| database_user_roles | Map of database user roles | map | read/write all databases | no |
| database_user_scopes | Database user scope | map | Scoped to the created cluster | no |
| cluster_type | Cluster type | string | REPLICASET | no |
| create_database_user | Whether to create a database user account | bool | true | no |
| electable_nodes | Number of electable nodes | number | 3 | no |
| kubernetes_create_secret | Whether to create a Kubernetes secret | bool | true | no |
| kubernetes_namespace | The namespace where a Kubernetes secret should be created | string | var.app_name | no |
| labels | Labels (tags) to apply to created resources | map | N/A | no |
| mongodbatlas_project_name | The name of the MongoDB Atlas project where the cluster is to be created | string | N/A | yes |
| mongo_db_major_version | MongoDB version | string | 4.4 | no |
| num_shards | Number of shards | number | 1 | no |
| provider_backup_enabled | Enable provider backup | bool | true | no |
| provider_disk_type_name | Disk type (Azure) | string | P2 | no |
| provider_instance_size_name | Provider instance size name (Azure) | string | M10 | no |
| read_only_nodes | Number of read only nodes | number | 0 | no |
| region | Azure region where the cluster should be deployed | string | NORWAY_EAST | no |
| region_priority | Election priority of the region | number | 7 | no |

## Outputs

| Name | Description |
|------|-------------|
| project_id | The MongoDB Atlas project ID |
| cluster_name | The name of the created cluster |
| connection_string_privatelink | Privatelink connection string (empty if not available) |
| connection_string_privatelink_srv | Privatelink SRV connection string (empty if not available) |
| connection_string_standard | Standard connection string |
| connection_string_standard_srv | Standard connection string SRV |
| nodes_privatelink | Map of the created cluster's private endpoint aware hosts and ports |
| nodes_standard | Map of the created cluster's hosts and ports |

### Example Kubernetes secret

```
apiVersion: v1
data:
  MONGODB_CONNSTR: ...
  MONGODB_CONNSTR_PRIVATELINK: ...
  MONGODB_CONNSTR_PRIVATELINK_SRV: ...
  MONGODB_CONNSTR_SRV: ...
  MONGODB_HOST0: ...
  MONGODB_HOST0_PRIVATELINK: ...
  MONGODB_HOST1: ...
  MONGODB_HOST1_PRIVATELINK: ...
  MONGODB_HOST2: ...
  MONGODB_HOST2_PRIVATELINK: ...
  MONGODB_HOST3: ""
  MONGODB_HOST3_PRIVATELINK: ""
  MONGODB_HOST4: ""
  MONGODB_HOST4_PRIVATELINK: ""
  MONGODB_HOST5: ""
  MONGODB_HOST5_PRIVATELINK: ""
  MONGODB_PASSWORD: ...
  MONGODB_PORT0: ...
  MONGODB_PORT0_PRIVATELINK: ...
  MONGODB_PORT1: ...
  MONGODB_PORT1_PRIVATELINK: ...
  MONGODB_PORT2: ...
  MONGODB_PORT2_PRIVATELINK: ...
  MONGODB_PORT3: ...
  MONGODB_PORT3_PRIVATELINK: ""
  MONGODB_PORT4: ...
  MONGODB_PORT4_PRIVATELINK: ""
  MONGODB_PORT5: ...
  MONGODB_PORT5_PRIVATELINK: ""
  MONGODB_USERNAME: ...
kind: Secret
[...]
```