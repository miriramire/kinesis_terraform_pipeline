# S3 buckets
module "s3_bucket_output" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_output_name
  acl    = "private"
}

module "s3_bucket_landing" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_landing_name
  acl    = "private"
}

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "dataeng-firehose-streaming-s3"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = module.s3_bucket_landing.s3_bucket_arn
    buffering_size     = var.firehose_buffer_details.size
    buffering_interval = var.firehose_buffer_details.interval
    dynamic_partitioning_configuration {
      enabled = "true"
    }
    prefix              = var.firehose_buffer_details.prefix
    error_output_prefix = var.firehose_buffer_details.error_output_prefix
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "my-firehose-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# AWS Glue database
resource "aws_glue_catalog_database" "streaming_database" {
  name = "streaming-db"
}

# AWS Glue Crawler
resource "aws_glue_crawler" "streaming_crawler" {
  name            = "dataeng-streaming-crawler"
  role            = aws_iam_role.glue_crawler_role.arn
  database_name   = aws_glue_catalog_database.streaming_database.name
  s3_targets {
    path = module.s3_bucket_landing.s3_bucket_arn
  }
}

resource "aws_iam_role" "glue_crawler_role" {
  name = "glue-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "glue_crawler_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role       = aws_iam_role.glue_crawler_role.name
}
