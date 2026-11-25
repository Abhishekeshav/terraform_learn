# Who may use the role: EMR Serverless jobs.
data "aws_iam_policy_document" "spark_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["emr-serverless.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "spark_job" {
  name               = "${local.name_prefix}-spark-job-role"
  assume_role_policy = data.aws_iam_policy_document.spark_trust.json
}

# What the role may do: least privilege.
data "aws_iam_policy_document" "spark_s3" {
  statement {
    sid       = "ListZoneBuckets"
    actions   = ["s3:ListBucket"]
    resources = [for b in aws_s3_bucket.zone : b.arn]
  }

  statement {
    sid       = "ReadRaw"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.zone["raw"].arn}/*"]
  }

  statement {
    sid       = "WriteCurated"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.zone["curated"].arn}/*"]
  }
}

resource "aws_iam_role_policy" "spark_s3" {
  name   = "s3-data-lake-access"
  role   = aws_iam_role.spark_job.id
  policy = data.aws_iam_policy_document.spark_s3.json
}
