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