variable "s3_bucket_landing_name" {
  description = "Kinesis Firehose will send data to this bucket"
  type        = string
  default     = "dataeng-landing-zone-us-east-2-kinesis-test"
}

variable "s3_bucket_output_name" {
  description = "Glue will store crawler data here"
  type        = string
  default     = "dataeng-output-zone-us-east-2-kinesis-test"
}

variable "firehose_buffer_details" {
  description = "Define buffer details"
  
  type = object({
    size                = number
    interval            = number
    prefix              = string
    error_output_prefix = string
  })

  default = {
    size                = 1 # MB
    interval            = 60 # seconds
    prefix              = "streaming/!{timestamp:yyyy/MM/}"
    error_output_prefix = "!{firehose:error-output-type}/!{timestamp:yyyy/MM/}"
  }
}