module "s3_bucket_output" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_name
  acl    = "private"
}

module "s3_bucket_landing" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_name
  acl    = "private"
}