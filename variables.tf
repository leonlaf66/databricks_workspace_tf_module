###common_tags
variable "common_tags" {
  description = "A map of common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The aws region of the workspace"
  type        = string    
}

###network
variable "vpc_id" {
  description = "VPC ID where Databricks subnets will be created"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
  default     = []
}

variable "subnet_cidrs" {
  description = "CIDR blocks for the 3 Databricks subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


###security_group
variable "ingress_rule" {
  description = "A list of ingress rules to apply to the security group."
  type = list(object({
    description                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    ip_protocol                  = string
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = []
}

variable "egress_rule" {
  description = "A list of egress rules to apply to the security group."
  type = list(object({
    description                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    ip_protocol                  = string
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = [{
    description = "Allow all outbound traffic"
    ip_protocol = "-1"
    cidr_ipv4   = "0.0.0.0/0"
    from_port   = null
    to_port     = null
     referenced_security_group_id = null
  }]
}

variable "sec_group_desc" {
  description = "A description for the security group."
  type        = string
  default     = "Security group managed by Terraform"
}

###databricks
variable "create_metastore" {
  type        = bool
  description = "Set to true to create a new Unity Catalog metastore and its required S3 bucket."
  default     = true
}

variable "databricks_account_id" {
  type        = string
  description = "The account ID for your Databricks deployment."
}

variable "metastore_owner" {
  type        = string
  description = "The email address of the user who will own the new metastore. Required if create_metastore is true."
  default     = ""
}

variable "metastore_id" {
  type        = string
  description = "The ID of an existing metastore to assign to the workspace. Used if create_metastore is false."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Set to true to allow the metastore to be destroyed even if it contains objects."
  default     = false
}

variable "workspace_name" {
  description = "The name of the new workspace"
  type        = string    
}