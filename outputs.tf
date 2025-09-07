output "workspace_id" {
  description = "The ID of the created Databricks workspace."
  value       = databricks_mws_workspaces.this.workspace_id
}

output "workspace_url" {
  description = "The URL of the created Databricks workspace."
  value       = databricks_mws_workspaces.this.workspace_url
}

output "cross_account_role_arn" {
  description = "ARN of the cross-account role created for Databricks."
  value       = aws_iam_role.databricks_workspace_role.arn
}

output "instance_profile_arn" {
  description = "ARN of the instance profile for Databricks clusters."
  value       = aws_iam_instance_profile.instance_profile.arn
}