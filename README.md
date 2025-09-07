<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.databricks_workspace_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.databricks_workspace_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.databricks_workspace_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.metastore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.metastore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.metastore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.metastore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.databricks_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_security_group_egress_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [databricks_metastore.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore) | resource |
| [databricks_metastore_assignment.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment) | resource |
| [databricks_mws_credentials.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_credentials) | resource |
| [databricks_mws_networks.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks) | resource |
| [databricks_mws_storage_configurations.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations) | resource |
| [databricks_mws_workspaces.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.databricks_workspace_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.root_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones for the subnets | `list(string)` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The aws region of the workspace | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of common tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_create_metastore"></a> [create\_metastore](#input\_create\_metastore) | Set to true to create a new Unity Catalog metastore and its required S3 bucket. | `bool` | `true` | no |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | The account ID for your Databricks deployment. | `string` | n/a | yes |
| <a name="input_egress_rule"></a> [egress\_rule](#input\_egress\_rule) | A list of egress rules to apply to the security group. | <pre>list(object({<br/>    description                  = string<br/>    from_port                    = optional(number)<br/>    to_port                      = optional(number)<br/>    ip_protocol                  = string<br/>    cidr_ipv4                    = optional(string)<br/>    referenced_security_group_id = optional(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_ipv4": "0.0.0.0/0",<br/>    "description": "Allow all outbound traffic",<br/>    "from_port": null,<br/>    "ip_protocol": "-1",<br/>    "referenced_security_group_id": null,<br/>    "to_port": null<br/>  }<br/>]</pre> | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Set to true to allow the metastore to be destroyed even if it contains objects. | `bool` | `false` | no |
| <a name="input_ingress_rule"></a> [ingress\_rule](#input\_ingress\_rule) | A list of ingress rules to apply to the security group. | <pre>list(object({<br/>    description                  = string<br/>    from_port                    = optional(number)<br/>    to_port                      = optional(number)<br/>    ip_protocol                  = string<br/>    cidr_ipv4                    = optional(string)<br/>    referenced_security_group_id = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_metastore_id"></a> [metastore\_id](#input\_metastore\_id) | The ID of an existing metastore to assign to the workspace. Used if create\_metastore is false. | `string` | `null` | no |
| <a name="input_metastore_owner"></a> [metastore\_owner](#input\_metastore\_owner) | The email address of the user who will own the new metastore. Required if create\_metastore is true. | `string` | `""` | no |
| <a name="input_sec_group_desc"></a> [sec\_group\_desc](#input\_sec\_group\_desc) | A description for the security group. | `string` | `"Security group managed by Terraform"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks for the 3 Databricks subnets | `list(string)` | <pre>[<br/>  "10.0.1.0/24",<br/>  "10.0.2.0/24",<br/>  "10.0.3.0/24"<br/>]</pre> | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | The name of the new workspace | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_role_arn"></a> [cross\_account\_role\_arn](#output\_cross\_account\_role\_arn) | ARN of the cross-account role created for Databricks. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The ID of the created Databricks workspace. |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | The URL of the created Databricks workspace. |
<!-- END_TF_DOCS -->