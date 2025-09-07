data "aws_availability_zones" "available" {
  count = length(var.availability_zones) == 0 ? 1 : 0
  state = "available"
}

data "aws_vpc" "selected" {
  filter {
    name   = "is-default"
    values = ["true"]
  }
}

locals {
  azs = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available[0].names, 0, 3)
}

# Create Databricks subnets
resource "aws_subnet" "databricks_subnets" {
  count = 3

  vpc_id            = data.aws_vpc.selected.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
     Name      = "${var.workspace_name}-databricks-subnet-${count.index + 1}"
    }
  )
}