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

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "dataeng-firehose-streaming-s3"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn = aws_iam_role.firehose_role.arn
    bucket_arn = module.s3_bucket_landing.bucket_arn
    buffer_size = var.firehose_buffer_details.size
    buffer_interval = var.firehose_buffer_details.interval
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