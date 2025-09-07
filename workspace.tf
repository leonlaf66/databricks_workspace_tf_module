locals {
  prefix = var.workspace_name

  assigned_metastore_id = var.create_metastore ? one(databricks_metastore.this[*].id) : var.metastore_id
}

# 1. Credentials for the cross-account role
resource "databricks_mws_credentials" "this" {
  account_id       = var.databricks_account_id
  credentials_name = "${local.prefix}-creds"
  role_arn         = aws_iam_role.databricks_workspace_role.arn
}

# 2. Storage configuration for the workspace's root S3 bucket
resource "databricks_mws_storage_configurations" "this" {
  account_id                 = var.databricks_account_id
  storage_configuration_name = "${local.prefix}-storage-config"
  bucket_name                = aws_s3_bucket.root.id
}

# 3. Network configuration for the workspace's VPC
resource "databricks_mws_networks" "this" {
  account_id         = var.databricks_account_id
  network_name       = "${local.prefix}-network"
  vpc_id             = data.aws_vpc.selected.id
  subnet_ids         = aws_subnet.databricks_subnets[*].id
  security_group_ids = [aws_security_group.this.id]
}

# 4. The Databricks workspace itself
resource "databricks_mws_workspaces" "this" {
  account_id     = var.databricks_account_id
  workspace_name = var.workspace_name
  aws_region     = var.aws_region

  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id
}

# This resource is only created if var.create_metastore is true.
resource "databricks_metastore" "this" {
  count = var.create_metastore ? 1 : 0

  name         = "${local.prefix}-metastore"
  storage_root = "s3://${aws_s3_bucket.metastore[0].id}/metastore"
  owner        = var.metastore_owner
  region       = var.aws_region
  force_destroy = var.force_destroy
}

# This resource is only created if a metastore is being created OR an existing one is provided.
resource "databricks_metastore_assignment" "this" {
  metastore_id = local.assigned_metastore_id
  workspace_id = databricks_mws_workspaces.this.workspace_id
}