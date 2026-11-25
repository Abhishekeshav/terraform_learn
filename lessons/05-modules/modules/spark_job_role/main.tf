# Trust policy: WHO may use the role.
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [var.trusted_service]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-spark-job-role"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

# Permissions policy: WHAT the role may do.
data "aws_iam_policy_document" "s3" {
  statement {
    sid       = "ListBuckets"
    actions   = ["s3:ListBucket"]
    resources = concat(var.read_bucket_arns, var.write_bucket_arns)
  }

  statement {
    sid       = "ReadObjects"
    actions   = ["s3:GetObject"]
    resources = [for arn in var.read_bucket_arns : "${arn}/*"]
  }

  statement {
    sid       = "WriteObjects"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [for arn in var.write_bucket_arns : "${arn}/*"]
  }
}

resource "aws_iam_role_policy" "s3" {
  name   = "s3-data-lake-access"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.s3.json
}
