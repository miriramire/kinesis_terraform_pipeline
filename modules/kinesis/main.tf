module "firehose" {
  source = "./firehose"

  firehose_name   = "my-firehose-stream"
  s3_bucket_name  = "my-s3-bucket"
}