# S3 buckets
module "s3_bucket_landing" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_landing_name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = var.firehose_buffer_details.name
  destination = "extended_s3" # s3 Deprecated, use extended_s3 instead

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = module.s3_bucket_landing.s3_bucket_arn
    buffering_size     = var.firehose_buffer_details.size
    buffering_interval = var.firehose_buffer_details.interval
    #dynamic_partitioning_configuration {
    #  enabled        = "true"
    #  retry_duration = 300
    #}
    prefix              = var.firehose_buffer_details.prefix
    error_output_prefix = var.firehose_buffer_details.error_output_prefix
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "my-firehose-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      }
    ]
  })
}

# AWS Glue database
resource "aws_glue_catalog_database" "streaming_database" {
  name = var.glue_details.database_name
}

# AWS Glue Crawler
resource "aws_glue_crawler" "streaming_crawler" {
  database_name   = aws_glue_catalog_database.streaming_database.name
  name            = var.glue_details.crawler_name
  role            = aws_iam_role.glue_crawler_role.arn
  s3_target {
    #path = module.s3_bucket_landing.s3_bucket_arn
    path = module.s3_bucket_landing.s3_bucket_id
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
