# --- Workspace Root S3 Bucket ---
resource "aws_s3_bucket" "root" {
  bucket = "${local.prefix}-root-bucket"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.workspace_name}-databricks-storage-bucket"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "root" {
  bucket = aws_s3_bucket.root.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "root" {
  bucket = aws_s3_bucket.root.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root" {
  bucket = aws_s3_bucket.root.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


data "aws_iam_policy_document" "root_bucket_policy" {
  statement {
    sid    = "GrantDatabricksAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:root"]
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [
      aws_s3_bucket.root.arn,
      "${aws_s3_bucket.root.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/DatabricksAccountId"
      values   = [var.databricks_account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "root" {
  bucket = aws_s3_bucket.root.id
  policy = data.aws_iam_policy_document.root_bucket_policy.json
}

# This bucket is only created if var.create_metastore_bucket is true.
resource "aws_s3_bucket" "metastore" {
  count  = var.create_metastore ? 1 : 0
  bucket = "${local.prefix}-metastore-bucket"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.workspace_name}-databricks-metastore-bucket"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "metastore" {
  count  = var.create_metastore ? 1 : 0
  bucket = aws_s3_bucket.metastore[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "metastore" {
  count  = var.create_metastore ? 1 : 0
  bucket = aws_s3_bucket.metastore[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "metastore" {
  count  = var.create_metastore ? 1 : 0
  bucket = aws_s3_bucket.metastore[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}