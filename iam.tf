data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = var.databricks_account_id
    }
  }
}

data "aws_iam_policy_document" "databricks_workspace_policy" {
  statement {
    sid    = "Stmt1403287045000"
    effect = "Allow"
    
    actions = [
      "ec2:AssociateIamInstanceProfile",
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CancelSpotInstanceRequests",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeIamInstanceProfileAssociations",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNatGateways",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribePrefixLists",
      "ec2:DescribeReservedInstancesOfferings",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcs",
      "ec2:DetachVolume",
      "ec2:DisassociateIamInstanceProfile",
      "ec2:ReplaceIamInstanceProfileAssociation",
      "ec2:RequestSpotInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeFleetHistory",
      "ec2:ModifyFleet",
      "ec2:DeleteFleets",
      "ec2:DescribeFleetInstances",
      "ec2:DescribeFleets",
      "ec2:CreateFleet",
      "ec2:DeleteLaunchTemplate",
      "ec2:GetLaunchTemplateData",
      "ec2:CreateLaunchTemplate",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:ModifyLaunchTemplate",
      "ec2:DeleteLaunchTemplateVersions",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:AssignPrivateIpAddresses",
      "ec2:GetSpotPlacementScores"
    ]
    
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    
    actions = [
      "iam:CreateServiceLinkedRole",
      "iam:PutRolePolicy"
    ]
    
    resources = ["arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot"]
    
    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["spot.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    
    actions = ["iam:PassRole"]
    
    resources = ["arn:aws:iam::*:role/${var.workspace_name}-databricks-workspace-role"]
  }
}

resource "aws_iam_role" "databricks_workspace_role" {
  name               = "${var.workspace_name}-databricks-workspace-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name        = "${var.workspace_name}-databricks-workspace-role"
    Purpose     = "Databricks Workspace"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "databricks_workspace_policy" {
  name        = "${var.workspace_name}-databricks-workspace-policy"
  description = "Policy for Databricks workspace operations"
  policy      = data.aws_iam_policy_document.databricks_workspace_policy.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.workspace_name}-databricks-workspace-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "databricks_workspace_policy_attachment" {
  role       = aws_iam_role.databricks_workspace_role.name
  policy_arn = aws_iam_policy.databricks_workspace_policy.arn
}