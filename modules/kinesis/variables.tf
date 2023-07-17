variable "environment" {
  description = "Development Environment"
  
  type = object ({
    name           = string
  })

  default = {
    name = "dev"
  }
}

variable "firehose_name" {
  description = "Name of the Kinesis Data Firehose stream"
  type        = string
  default = {
    name = "dataeng-firehose-streaming-s3"
  }
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store the data"
  type        = string
  default = {
    name = "dataeng-landing-zone-us-east-2-kinesis-test"
  }
}